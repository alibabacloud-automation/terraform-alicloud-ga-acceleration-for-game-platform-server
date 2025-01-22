Terraform module to build GA Acceleration for Game Platform Server on Alibaba Cloud

terraform-alicloud-ga-acceleration-for-game-platform-server
======================================

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-ga-acceleration-for-game-platform-server/blob/main/README-CN.md)

In the game scenario, the platform server is mostly deployed in a centralized manner, and it carries important business modules such as login and payment. A high latency can affect the game experience of players. Therefore, for cross-regional access to the platform server, a global acceleration capability at the network layer can be deployed to reduce the latency of players' access to the platform server. Acceleration access is supported for TCP/UDP/HTTP/HTTPS protocols. At the same time, the acceleration capability can be used in combination with security capabilities such as DDoS and WAF, to achieve coordinated operation of acceleration and security protection.


Architecture Diagram:

![image](https://raw.githubusercontent.com/alibabacloud-automation/terraform-alicloud-ga-acceleration-for-game-platform-server/main/scripts/diagram.png)


## Usage


```hcl
provider "alicloud" {
  region = "ap-southeast-1"
}

module "complete" {
  source = "alibabacloud-automation/ga-acceleration-for-game-platform-server/alicloud"

  vpc = {
    name       = "tf-example"
    cidr_block = "172.16.0.0/12"
  }

  vswitch_zones = ["ap-southeast-1a", "ap-southeast-1b"]

  alb_server_group = {
    server_group_name = "tf-example"
    health_check_config = {
      health_check_host = "tf-example-platform-server.com"
      health_check_path = "/tf-example-platform-server"
    }
  }

  ga_accelerator = {
    cross_border_status    = true
    bandwidth_billing_type = "CDT"
    cross_border_mode      = "bgpPro"
  }

  ga_endpoint_group = {
    endpoint_group_region = "ap-southeast-1"
    description           = "tf-example"
  }

  ga_accelerate_regions = {
    "cn-shanghai"    = { bandwidth = 200, ip_version = "IPv4" }
    "cn-beijing"     = { bandwidth = 200, ip_version = "IPv4" }
    "eu-central-1"   = { bandwidth = 200, ip_version = "IPv4" }
    "us-east-1"      = { bandwidth = 200, ip_version = "IPv4" }
    "ap-northeast-1" = { bandwidth = 200, ip_version = "IPv4" }
    "ap-southeast-3" = { bandwidth = 200, ip_version = "IPv4" }
  }
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-ga-acceleration-for-game-platform-server/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ga_service"></a> [ga\_service](#module\_ga\_service) | ./modules/ga_service | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_ga_accelerator.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ga_accelerator) | resource |
| [alicloud_ga_endpoint_group.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ga_endpoint_group) | resource |
| [alicloud_ga_ip_set.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ga_ip_set) | resource |
| [alicloud_ga_listener.http_80](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ga_listener) | resource |
| [time_sleep.wait_for_ga_initialization](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_load_balancer"></a> [alb\_load\_balancer](#input\_alb\_load\_balancer) | Configuration for the ALB load balancer. | <pre>object({<br>    load_balancer_edition  = optional(string, "Basic")<br>    address_type           = optional(string, "Internet")<br>    address_allocated_mode = optional(string, "Fixed")<br>    load_balancer_name     = optional(string, null)<br>    load_balancer_billing_config = optional(object({<br>      pay_type = optional(string, "PayAsYouGo")<br>    }), {})<br>    modification_protection_config = optional(object({<br>      status = optional(string, "NonProtection")<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_alb_server_group"></a> [alb\_server\_group](#input\_alb\_server\_group) | Configuration for the ALB server group. | <pre>object({<br>    server_group_name = string<br>    protocol          = optional(string, "HTTP")<br>    health_check_config = object({<br>      health_check_connect_port = optional(string, "80")<br>      health_check_enabled      = optional(bool, true)<br>      health_check_host         = string<br>      health_check_codes        = optional(list(string), ["http_2xx", "http_3xx", "http_4xx"])<br>      health_check_http_version = optional(string, "HTTP1.1")<br>      health_check_interval     = optional(number, 2)<br>      health_check_method       = optional(string, "HEAD")<br>      health_check_path         = string<br>      health_check_protocol     = optional(string, "HTTP")<br>      health_check_timeout      = optional(number, 5)<br>      healthy_threshold         = optional(number, 3)<br>      unhealthy_threshold       = optional(number, 3)<br>    })<br>    sticky_session_config = optional(object({<br>      sticky_session_enabled = optional(bool, false)<br>      cookie                 = optional(string, null)<br>    }), {})<br>  })</pre> | n/a | yes |
| <a name="input_create_ga_service"></a> [create\_ga\_service](#input\_create\_ga\_service) | Whether to create the GA service resources. | `bool` | `true` | no |
| <a name="input_ga_accelerate_regions"></a> [ga\_accelerate\_regions](#input\_ga\_accelerate\_regions) | Configuration for the GA accelerate regions. | <pre>map(object({<br>    bandwidth  = optional(number, 200)<br>    ip_version = optional(string, "IPv4")<br>    isp_type   = optional(string, "BGP")<br>  }))</pre> | `{}` | no |
| <a name="input_ga_accelerator"></a> [ga\_accelerator](#input\_ga\_accelerator) | Configuration for the GA accelerator. | <pre>object({<br>    accelerator_name       = optional(string, null)<br>    description            = optional(string, null)<br>    payment_type           = optional(string, "PayAsYouGo")<br>    cross_border_status    = optional(bool, null)<br>    bandwidth_billing_type = optional(string, null)<br>    cross_border_mode      = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_ga_endpoint_group"></a> [ga\_endpoint\_group](#input\_ga\_endpoint\_group) | Configuration object for the GA endpoint group. | <pre>object({<br>    endpoint_group_region = string<br>    description           = optional(string, null)<br>    endpoint_group_type   = optional(string, "default")<br>    endpoint_configurations = optional(list(object({<br>      endpoint = string<br>      type     = string<br>      weight   = number<br>    })), [])<br>  })</pre> | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | Configuration for ECS instances. | <pre>object({<br>    image_id                   = optional(string, "ubuntu_18_04_64_20G_alibase_20190624.vhd") # Replace with actual image ID<br>    instance_type              = optional(string, "ecs.t5-lc1m1.small")                       # Replace with actual instance type<br>    internet_charge_type       = optional(string, "PayByTraffic")<br>    internet_max_bandwidth_out = optional(number, 5)<br>    system_disk_category       = optional(string, "cloud_efficiency")<br>  })</pre> | `{}` | no |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | Configuration for the security group. | <pre>object({<br>    security_group_name = optional(string, null)<br>    description         = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | Configuration for the VPC. | <pre>object({<br>    cidr_block  = string<br>    vpc_name    = optional(string, null)<br>    description = optional(string, null)<br>  })</pre> | <pre>{<br>  "cidr_block": "172.16.0.0/12"<br>}</pre> | no |
| <a name="input_vswitch_zones"></a> [vswitch\_zones](#input\_vswitch\_zones) | The zones of the vswitch. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_a_service_alb_listener_id"></a> [a\_service\_alb\_listener\_id](#output\_a\_service\_alb\_listener\_id) | The ID of the ALB listener for the GA service. |
| <a name="output_ga_accelerator_id"></a> [ga\_accelerator\_id](#output\_ga\_accelerator\_id) | The ID of the GA accelerator. |
| <a name="output_ga_endpoint_group_id"></a> [ga\_endpoint\_group\_id](#output\_ga\_endpoint\_group\_id) | The ID of the GA endpoint group. |
| <a name="output_ga_ip_set_ids"></a> [ga\_ip\_set\_ids](#output\_ga\_ip\_set\_ids) | The IDs of the GA IP sets. |
| <a name="output_ga_listener_id"></a> [ga\_listener\_id](#output\_ga\_listener\_id) | The ID of the GA listener for HTTP 80. |
| <a name="output_ga_service_alb_load_balancer_id"></a> [ga\_service\_alb\_load\_balancer\_id](#output\_ga\_service\_alb\_load\_balancer\_id) | The ID of the ALB load balancer for the GA service. |
| <a name="output_ga_service_alb_server_group_id"></a> [ga\_service\_alb\_server\_group\_id](#output\_ga\_service\_alb\_server\_group\_id) | The ID of the ALB server group for the GA service. |
| <a name="output_ga_service_instance_ids"></a> [ga\_service\_instance\_ids](#output\_ga\_service\_instance\_ids) | The IDs of the ECS instances for the GA service. |
| <a name="output_ga_service_security_group_id"></a> [ga\_service\_security\_group\_id](#output\_ga\_service\_security\_group\_id) | The ID of the security group for the GA service. |
| <a name="output_ga_service_vpc_id"></a> [ga\_service\_vpc\_id](#output\_ga\_service\_vpc\_id) | The ID of the VPC for the GA service. |
| <a name="output_ga_service_vswitch_ids"></a> [ga\_service\_vswitch\_ids](#output\_ga\_service\_vswitch\_ids) | The IDs of the VSwitches for the GA service. |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
