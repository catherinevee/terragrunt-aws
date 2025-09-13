# Application Load Balancer Module - Outputs

output "arn" {
  description = "ARN of the load balancer"
  value       = module.alb.arn
}

output "arn_suffix" {
  description = "ARN suffix of the load balancer"
  value       = module.alb.arn_suffix
}

output "dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.dns_name
}

output "hosted_zone_id" {
  description = "Hosted zone ID of the load balancer"
  value       = module.alb.hosted_zone_id
}

output "id" {
  description = "ID of the load balancer"
  value       = module.alb.id
}

output "name" {
  description = "Name of the load balancer"
  value       = module.alb.name
}

output "security_group_id" {
  description = "Security group ID of the load balancer"
  value       = module.alb.security_group_id
}

output "target_group_arns" {
  description = "ARNs of the target groups"
  value       = module.alb.target_group_arns
}

output "target_group_arn_suffixes" {
  description = "ARN suffixes of the target groups"
  value       = module.alb.target_group_arn_suffixes
}

output "target_group_names" {
  description = "Names of the target groups"
  value       = module.alb.target_group_names
}

output "listener_arns" {
  description = "ARNs of the listeners"
  value       = module.alb.listener_arns
}

output "listener_ids" {
  description = "IDs of the listeners"
  value       = module.alb.listener_ids
}
