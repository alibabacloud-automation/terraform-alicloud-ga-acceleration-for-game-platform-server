module "ga_service" {
  count = var.create_ga_service ? 1 : 0

  source            = "./modules/ga_service"
  vpc               = var.vpc
  security_group    = var.security_group
  vswitch_zones     = var.vswitch_zones
  instance          = var.instance
  alb_load_balancer = var.alb_load_balancer
  alb_server_group  = var.alb_server_group
}

resource "alicloud_ga_accelerator" "this" {
  accelerator_name       = var.ga_accelerator.accelerator_name
  description            = var.ga_accelerator.description
  payment_type           = var.ga_accelerator.payment_type
  cross_border_status    = var.ga_accelerator.cross_border_status
  bandwidth_billing_type = var.ga_accelerator.bandwidth_billing_type
  cross_border_mode      = var.ga_accelerator.cross_border_mode
}

resource "alicloud_ga_listener" "http_80" {
  accelerator_id = alicloud_ga_accelerator.this.id
  port_ranges {
    from_port = 80
    to_port   = 80
  }
  protocol = "HTTP"
}

locals {
  endpoint_configurations = var.create_ga_service ? [
    { endpoint : one(module.ga_service[*].alb_load_balancer_id)
      type : "ALB"
      weight : 100
    }
  ] : var.ga_endpoint_group.endpoint_configurations
}

resource "alicloud_ga_endpoint_group" "this" {
  accelerator_id        = alicloud_ga_accelerator.this.id
  endpoint_group_region = var.ga_endpoint_group.endpoint_group_region
  description           = var.ga_endpoint_group.description
  endpoint_group_type   = var.ga_endpoint_group.endpoint_group_type
  listener_id           = alicloud_ga_listener.http_80.id

  dynamic "endpoint_configurations" {
    for_each = local.endpoint_configurations
    content {
      endpoint = endpoint_configurations.value.endpoint
      type     = endpoint_configurations.value.type
      weight   = endpoint_configurations.value.weight
    }
  }
}

resource "time_sleep" "wait_for_ga_initialization" {
  create_duration = "60s"
  depends_on = [
    alicloud_ga_endpoint_group.this
  ]
}

resource "alicloud_ga_ip_set" "this" {
  for_each             = var.ga_accelerate_regions
  accelerate_region_id = each.key
  bandwidth            = each.value.bandwidth
  ip_version           = each.value.ip_version
  isp_type             = each.value.isp_type
  accelerator_id       = alicloud_ga_accelerator.this.id
  depends_on = [
    time_sleep.wait_for_ga_initialization
  ]
  timeouts {
    create = "20m"
  }
}
