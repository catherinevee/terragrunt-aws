# Security Groups Module - Outputs

output "security_group_id" {
  description = "ID of the security group"
  value       = module.security_groups.security_group_id
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = module.security_groups.security_group_arn
}

output "security_group_vpc_id" {
  description = "VPC ID"
  value       = module.security_groups.security_group_vpc_id
}

output "security_group_owner_id" {
  description = "Owner ID"
  value       = module.security_groups.security_group_owner_id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = module.security_groups.security_group_name
}

output "security_group_description" {
  description = "Description of the security group"
  value       = module.security_groups.security_group_description
}

# Note: security_group_ingress and security_group_egress are not available in the terraform-aws-modules/security-group/aws module
# These outputs have been removed to avoid errors

output "additional_security_group_ids" {
  description = "Map of additional security group IDs"
  value       = { for k, v in aws_security_group.additional : k => v.id }
}

output "additional_security_group_arns" {
  description = "Map of additional security group ARNs"
  value       = { for k, v in aws_security_group.additional : k => v.arn }
}
