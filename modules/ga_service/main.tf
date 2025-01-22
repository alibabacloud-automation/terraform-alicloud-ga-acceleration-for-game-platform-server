resource "alicloud_vpc" "this" {
  vpc_name    = var.vpc.vpc_name
  cidr_block  = var.vpc.cidr_block
  description = var.vpc.description
}

resource "alicloud_security_group" "this" {
  vpc_id              = alicloud_vpc.this.id
  security_group_name = var.security_group.security_group_name
  description         = var.security_group.description
}

resource "alicloud_vswitch" "this" {
  count        = length(var.vswitch_zones)
  vpc_id       = alicloud_vpc.this.id
  cidr_block   = cidrsubnet(alicloud_vpc.this.cidr_block, 8, count.index)
  zone_id      = var.vswitch_zones[count.index]
  vswitch_name = "vswitch-${count.index + 1}"
}

resource "alicloud_instance" "this" {
  count                      = length(var.vswitch_zones)
  instance_name              = "ecs-instance-${count.index + 1}"
  image_id                   = var.instance.image_id
  instance_type              = var.instance.instance_type
  security_groups            = [alicloud_security_group.this.id]
  vswitch_id                 = alicloud_vswitch.this[count.index].id
  internet_charge_type       = var.instance.internet_charge_type
  internet_max_bandwidth_out = var.instance.internet_max_bandwidth_out
  system_disk_category       = var.instance.system_disk_category
}


resource "alicloud_alb_load_balancer" "this" {
  vpc_id                 = alicloud_vpc.this.id
  load_balancer_edition  = var.alb_load_balancer.load_balancer_edition
  address_type           = var.alb_load_balancer.address_type
  address_allocated_mode = var.alb_load_balancer.address_allocated_mode
  load_balancer_name     = var.alb_load_balancer.load_balancer_name

  load_balancer_billing_config {
    pay_type = var.alb_load_balancer.load_balancer_billing_config.pay_type
  }

  modification_protection_config {
    status = var.alb_load_balancer.modification_protection_config.status
  }

  dynamic "zone_mappings" {
    for_each = { for i, vsw in alicloud_vswitch.this : vsw.id => vsw.zone_id }
    content {
      vswitch_id = zone_mappings.key
      zone_id    = zone_mappings.value
    }
  }
}


resource "alicloud_alb_server_group" "this" {
  vpc_id            = alicloud_vpc.this.id
  protocol          = var.alb_server_group.protocol
  server_group_name = var.alb_server_group.server_group_name

  health_check_config {
    health_check_connect_port = var.alb_server_group.health_check_config.health_check_connect_port
    health_check_enabled      = var.alb_server_group.health_check_config.health_check_enabled
    health_check_host         = var.alb_server_group.health_check_config.health_check_host
    health_check_codes        = var.alb_server_group.health_check_config.health_check_codes
    health_check_http_version = var.alb_server_group.health_check_config.health_check_http_version
    health_check_interval     = var.alb_server_group.health_check_config.health_check_interval
    health_check_method       = var.alb_server_group.health_check_config.health_check_method
    health_check_path         = var.alb_server_group.health_check_config.health_check_path
    health_check_protocol     = var.alb_server_group.health_check_config.health_check_protocol
    health_check_timeout      = var.alb_server_group.health_check_config.health_check_timeout
    healthy_threshold         = var.alb_server_group.health_check_config.healthy_threshold
    unhealthy_threshold       = var.alb_server_group.health_check_config.unhealthy_threshold
  }

  dynamic "sticky_session_config" {
    for_each = [var.alb_server_group.sticky_session_config]
    content {
      sticky_session_enabled = sticky_session_config.value.sticky_session_enabled
      cookie                 = sticky_session_config.value.cookie
    }
  }

  dynamic "servers" {
    for_each = { for i, ecs in alicloud_instance.this : ecs.id => ecs.private_ip }
    content {
      description = "ga_service"
      port        = 80
      server_id   = servers.key
      server_ip   = servers.value
      server_type = "Ecs"
      weight      = 10
    }
  }
}

resource "alicloud_alb_listener" "http_80" {
  load_balancer_id     = alicloud_alb_load_balancer.this.id
  listener_protocol    = "HTTP"
  listener_port        = 80
  listener_description = "alb_listener_http"
  default_actions {
    type = "ForwardGroup"
    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.this.id
      }
    }
  }
}
