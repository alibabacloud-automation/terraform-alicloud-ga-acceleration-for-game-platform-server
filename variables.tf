variable "create_ga_service" {
  description = "Whether to create the GA service resources."
  type        = bool
  default     = true
}

variable "vpc" {
  description = "Configuration for the VPC."
  type = object({
    cidr_block  = string
    vpc_name    = optional(string, null)
    description = optional(string, null)
  })
  default = {
    cidr_block = "172.16.0.0/12"
  }
}

variable "security_group" {
  description = "Configuration for the security group."
  type = object({
    security_group_name = optional(string, null)
    description         = optional(string, null)
  })
  default = {}
}

variable "vswitch_zones" {
  description = "The zones of the vswitch."
  type        = list(string)
  default     = []
}

variable "instance" {
  description = "Configuration for ECS instances."
  type = object({
    image_id                   = optional(string, "ubuntu_18_04_64_20G_alibase_20190624.vhd") # Replace with actual image ID
    instance_type              = optional(string, "ecs.t5-lc1m1.small")                       # Replace with actual instance type
    internet_charge_type       = optional(string, "PayByTraffic")
    internet_max_bandwidth_out = optional(number, 5)
    system_disk_category       = optional(string, "cloud_efficiency")
  })
  default = {}
}

variable "alb_load_balancer" {
  description = "Configuration for the ALB load balancer."
  type = object({
    load_balancer_edition  = optional(string, "Basic")
    address_type           = optional(string, "Internet")
    address_allocated_mode = optional(string, "Fixed")
    load_balancer_name     = optional(string, null)
    load_balancer_billing_config = optional(object({
      pay_type = optional(string, "PayAsYouGo")
    }), {})
    modification_protection_config = optional(object({
      status = optional(string, "NonProtection")
    }), {})
  })
  default = {}
}

variable "alb_server_group" {
  description = "Configuration for the ALB server group."
  type = object({
    server_group_name = string
    protocol          = optional(string, "HTTP")
    health_check_config = object({
      health_check_connect_port = optional(string, "80")
      health_check_enabled      = optional(bool, true)
      health_check_host         = string
      health_check_codes        = optional(list(string), ["http_2xx", "http_3xx", "http_4xx"])
      health_check_http_version = optional(string, "HTTP1.1")
      health_check_interval     = optional(number, 2)
      health_check_method       = optional(string, "HEAD")
      health_check_path         = string
      health_check_protocol     = optional(string, "HTTP")
      health_check_timeout      = optional(number, 5)
      healthy_threshold         = optional(number, 3)
      unhealthy_threshold       = optional(number, 3)
    })
    sticky_session_config = optional(object({
      sticky_session_enabled = optional(bool, false)
      cookie                 = optional(string, null)
    }), {})
  })
}


variable "ga_accelerator" {
  description = "Configuration for the GA accelerator."
  type = object({
    accelerator_name       = optional(string, null)
    description            = optional(string, null)
    payment_type           = optional(string, "PayAsYouGo")
    cross_border_status    = optional(bool, null)
    bandwidth_billing_type = optional(string, null)
    cross_border_mode      = optional(string, null)
  })
  default = {}
}

variable "ga_endpoint_group" {
  description = "Configuration object for the GA endpoint group."
  type = object({
    endpoint_group_region = string
    description           = optional(string, null)
    endpoint_group_type   = optional(string, "default")
    endpoint_configurations = optional(list(object({
      endpoint = string
      type     = string
      weight   = number
    })), [])
  })
}

variable "ga_accelerate_regions" {
  description = "Configuration for the GA accelerate regions."
  type = map(object({
    bandwidth  = optional(number, 200)
    ip_version = optional(string, "IPv4")
    isp_type   = optional(string, "BGP")
  }))
  default = {}
}

