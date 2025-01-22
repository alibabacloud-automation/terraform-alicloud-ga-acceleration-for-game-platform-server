output "ga_accelerator_id" {
  description = "The ID of the GA accelerator."
  value       = alicloud_ga_accelerator.this.id
}

output "ga_listener_id" {
  description = "The ID of the GA listener for HTTP 80."
  value       = alicloud_ga_listener.http_80.id
}

output "ga_endpoint_group_id" {
  description = "The ID of the GA endpoint group."
  value       = alicloud_ga_endpoint_group.this.id
}

output "ga_ip_set_ids" {
  description = "The IDs of the GA IP sets."
  value       = { for region, ip_set in alicloud_ga_ip_set.this : region => ip_set.id }
}

output "a_service_alb_listener_id" {
  description = "The ID of the ALB listener for the GA service."
  value       = one(module.ga_service[*].alb_listener_id)
}


output "ga_service_alb_load_balancer_id" {
  description = "The ID of the ALB load balancer for the GA service."
  value       = one(module.ga_service[*].alb_load_balancer_id)
}

output "ga_service_alb_server_group_id" {
  description = "The ID of the ALB server group for the GA service."
  value       = one(module.ga_service[*].alb_server_group_id)
}

output "ga_service_instance_ids" {
  description = "The IDs of the ECS instances for the GA service."
  value       = one(module.ga_service[*].ecs_instance_ids)
}

output "ga_service_vswitch_ids" {
  description = "The IDs of the VSwitches for the GA service."
  value       = one(module.ga_service[*].vswitch_ids)
}

output "ga_service_security_group_id" {
  description = "The ID of the security group for the GA service."
  value       = one(module.ga_service[*].security_group_id)
}

output "ga_service_vpc_id" {
  description = "The ID of the VPC for the GA service."
  value       = one(module.ga_service[*].vpc_id)
}
