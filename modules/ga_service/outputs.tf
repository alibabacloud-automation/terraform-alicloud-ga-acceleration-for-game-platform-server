output "vpc_id" {
  description = "The ID of the VPC."
  value       = alicloud_vpc.this.id
}

output "security_group_id" {
  description = "The ID of the security group."
  value       = alicloud_security_group.this.id
}

output "vswitch_ids" {
  description = "The IDs of the vswitches."
  value       = alicloud_vswitch.this[*].id
}

output "ecs_instance_ids" {
  description = "The IDs of the ECS instances."
  value       = alicloud_instance.this[*].id
}

output "alb_load_balancer_id" {
  description = "The ID of the ALB load balancer."
  value       = alicloud_alb_load_balancer.this.id
}

output "alb_server_group_id" {
  description = "The ID of the ALB server group."
  value       = alicloud_alb_server_group.this.id
}

output "alb_listener_id" {
  description = "The ID of the ALB listener."
  value       = alicloud_alb_listener.http_80.id
}
