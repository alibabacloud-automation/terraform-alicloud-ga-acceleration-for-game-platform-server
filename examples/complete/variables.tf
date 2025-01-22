variable "vpc" {
  description = "Configuration for the VPC."
  type = object({
    cidr_block  = string
    vpc_name    = optional(string, null)
    description = optional(string, null)
  })
  default = {
    name       = "tf-example"
    cidr_block = "172.16.0.0/12"
  }
}

variable "vswitch_zones" {
  description = "The zones of the vswitch."
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
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
  default = {
    server_group_name = "tf-example"
    health_check_config = {
      health_check_host = "tf-example-platform-server.com"
      health_check_path = "/tf-example-platform-server"
    }
  }
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
  default = {
    cross_border_status    = true
    bandwidth_billing_type = "CDT"
    cross_border_mode      = "bgpPro"
  }
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
  default = {
    endpoint_group_region = "ap-southeast-1"
    description           = "tf-example"
  }
}

variable "ga_accelerate_regions" {
  description = "Configuration for the GA accelerate regions."
  type = map(object({
    bandwidth  = optional(number, 200)
    ip_version = optional(string, "IPv4")
    isp_type   = optional(string, "BGP")
  }))
  default = {
    "cn-shanghai"    = { bandwidth = 200, ip_version = "IPv4" }
    "cn-beijing"     = { bandwidth = 200, ip_version = "IPv4" }
    "eu-central-1"   = { bandwidth = 200, ip_version = "IPv4" }
    "us-east-1"      = { bandwidth = 200, ip_version = "IPv4" }
    "ap-northeast-1" = { bandwidth = 200, ip_version = "IPv4" }
    "ap-southeast-3" = { bandwidth = 200, ip_version = "IPv4" }
  }
}

