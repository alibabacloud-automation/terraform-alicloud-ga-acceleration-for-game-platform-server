
# Complete


## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.1.3 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_complete"></a> [complete](#module\_complete) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_load_balancer"></a> [alb\_load\_balancer](#input\_alb\_load\_balancer) | Configuration for the ALB load balancer. | <pre>object({<br>    load_balancer_edition  = optional(string, "Basic")<br>    address_type           = optional(string, "Internet")<br>    address_allocated_mode = optional(string, "Fixed")<br>    load_balancer_name     = optional(string, null)<br>    load_balancer_billing_config = optional(object({<br>      pay_type = optional(string, "PayAsYouGo")<br>    }), {})<br>    modification_protection_config = optional(object({<br>      status = optional(string, "NonProtection")<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_alb_server_group"></a> [alb\_server\_group](#input\_alb\_server\_group) | Configuration for the ALB server group. | <pre>object({<br>    server_group_name = string<br>    protocol          = optional(string, "HTTP")<br>    health_check_config = object({<br>      health_check_connect_port = optional(string, "80")<br>      health_check_enabled      = optional(bool, true)<br>      health_check_host         = string<br>      health_check_codes        = optional(list(string), ["http_2xx", "http_3xx", "http_4xx"])<br>      health_check_http_version = optional(string, "HTTP1.1")<br>      health_check_interval     = optional(number, 2)<br>      health_check_method       = optional(string, "HEAD")<br>      health_check_path         = string<br>      health_check_protocol     = optional(string, "HTTP")<br>      health_check_timeout      = optional(number, 5)<br>      healthy_threshold         = optional(number, 3)<br>      unhealthy_threshold       = optional(number, 3)<br>    })<br>    sticky_session_config = optional(object({<br>      sticky_session_enabled = optional(bool, false)<br>      cookie                 = optional(string, null)<br>    }), {})<br>  })</pre> | <pre>{<br>  "health_check_config": {<br>    "health_check_host": "tf-example-platform-server.com",<br>    "health_check_path": "/tf-example-platform-server"<br>  },<br>  "server_group_name": "tf-example"<br>}</pre> | no |
| <a name="input_create_ga_service"></a> [create\_ga\_service](#input\_create\_ga\_service) | Whether to create the GA service resources. | `bool` | `true` | no |
| <a name="input_ga_accelerate_regions"></a> [ga\_accelerate\_regions](#input\_ga\_accelerate\_regions) | Configuration for the GA accelerate regions. | <pre>map(object({<br>    bandwidth  = optional(number, 200)<br>    ip_version = optional(string, "IPv4")<br>    isp_type   = optional(string, "BGP")<br>  }))</pre> | <pre>{<br>  "ap-northeast-1": {<br>    "bandwidth": 200,<br>    "ip_version": "IPv4"<br>  },<br>  "ap-southeast-3": {<br>    "bandwidth": 200,<br>    "ip_version": "IPv4"<br>  },<br>  "cn-beijing": {<br>    "bandwidth": 200,<br>    "ip_version": "IPv4"<br>  },<br>  "cn-shanghai": {<br>    "bandwidth": 200,<br>    "ip_version": "IPv4"<br>  },<br>  "eu-central-1": {<br>    "bandwidth": 200,<br>    "ip_version": "IPv4"<br>  },<br>  "us-east-1": {<br>    "bandwidth": 200,<br>    "ip_version": "IPv4"<br>  }<br>}</pre> | no |
| <a name="input_ga_accelerator"></a> [ga\_accelerator](#input\_ga\_accelerator) | Configuration for the GA accelerator. | <pre>object({<br>    accelerator_name       = optional(string, null)<br>    description            = optional(string, null)<br>    payment_type           = optional(string, "PayAsYouGo")<br>    cross_border_status    = optional(bool, null)<br>    bandwidth_billing_type = optional(string, null)<br>    cross_border_mode      = optional(string, null)<br>  })</pre> | <pre>{<br>  "bandwidth_billing_type": "CDT",<br>  "cross_border_mode": "bgpPro",<br>  "cross_border_status": true<br>}</pre> | no |
| <a name="input_ga_endpoint_group"></a> [ga\_endpoint\_group](#input\_ga\_endpoint\_group) | Configuration object for the GA endpoint group. | <pre>object({<br>    endpoint_group_region = string<br>    description           = optional(string, null)<br>    endpoint_group_type   = optional(string, "default")<br>    endpoint_configurations = optional(list(object({<br>      endpoint = string<br>      type     = string<br>      weight   = number<br>    })), [])<br>  })</pre> | <pre>{<br>  "description": "tf-example",<br>  "endpoint_group_region": "ap-southeast-1"<br>}</pre> | no |
| <a name="input_instance"></a> [instance](#input\_instance) | Configuration for ECS instances. | <pre>object({<br>    image_id                   = optional(string, "ubuntu_18_04_64_20G_alibase_20190624.vhd") # Replace with actual image ID<br>    instance_type              = optional(string, "ecs.t5-lc1m1.small")                       # Replace with actual instance type<br>    internet_charge_type       = optional(string, "PayByTraffic")<br>    internet_max_bandwidth_out = optional(number, 5)<br>    system_disk_category       = optional(string, "cloud_efficiency")<br>  })</pre> | `{}` | no |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | Configuration for the security group. | <pre>object({<br>    security_group_name = optional(string, null)<br>    description         = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | Configuration for the VPC. | <pre>object({<br>    cidr_block  = string<br>    vpc_name    = optional(string, null)<br>    description = optional(string, null)<br>  })</pre> | <pre>{<br>  "cidr_block": "172.16.0.0/12",<br>  "name": "tf-example"<br>}</pre> | no |
| <a name="input_vswitch_zones"></a> [vswitch\_zones](#input\_vswitch\_zones) | The zones of the vswitch. | `list(string)` | <pre>[<br>  "ap-southeast-1a",<br>  "ap-southeast-1b"<br>]</pre> | no |

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