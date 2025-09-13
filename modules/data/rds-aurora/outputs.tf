# RDS Aurora Module - Outputs

output "cluster_identifier" {
  description = "The RDS cluster identifier"
  value       = module.rds_aurora.cluster_identifier
}

output "cluster_arn" {
  description = "The RDS cluster ARN"
  value       = module.rds_aurora.cluster_arn
}

output "cluster_endpoint" {
  description = "The RDS cluster endpoint"
  value       = module.rds_aurora.cluster_endpoint
}

output "cluster_reader_endpoint" {
  description = "The RDS cluster reader endpoint"
  value       = module.rds_aurora.cluster_reader_endpoint
}

output "cluster_hosted_zone_id" {
  description = "The RDS cluster hosted zone ID"
  value       = module.rds_aurora.cluster_hosted_zone_id
}

output "cluster_port" {
  description = "The RDS cluster port"
  value       = module.rds_aurora.cluster_port
}

output "cluster_database_name" {
  description = "The RDS cluster database name"
  value       = module.rds_aurora.cluster_database_name
}

output "cluster_master_username" {
  description = "The RDS cluster master username"
  value       = module.rds_aurora.cluster_master_username
  sensitive   = true
}

output "cluster_master_password" {
  description = "The RDS cluster master password"
  value       = module.rds_aurora.cluster_master_password
  sensitive   = true
}

output "cluster_backup_retention_period" {
  description = "The RDS cluster backup retention period"
  value       = module.rds_aurora.cluster_backup_retention_period
}

output "cluster_preferred_backup_window" {
  description = "The RDS cluster preferred backup window"
  value       = module.rds_aurora.cluster_preferred_backup_window
}

output "cluster_preferred_maintenance_window" {
  description = "The RDS cluster preferred maintenance window"
  value       = module.rds_aurora.cluster_preferred_maintenance_window
}

output "cluster_availability_zones" {
  description = "The RDS cluster availability zones"
  value       = module.rds_aurora.cluster_availability_zones
}

output "cluster_security_groups" {
  description = "The RDS cluster security groups"
  value       = module.rds_aurora.cluster_security_groups
}

output "cluster_db_subnet_group_name" {
  description = "The RDS cluster DB subnet group name"
  value       = module.rds_aurora.cluster_db_subnet_group_name
}

output "cluster_parameter_group_name" {
  description = "The RDS cluster parameter group name"
  value       = module.rds_aurora.cluster_parameter_group_name
}

output "cluster_status" {
  description = "The RDS cluster status"
  value       = module.rds_aurora.cluster_status
}

output "cluster_engine" {
  description = "The RDS cluster engine"
  value       = module.rds_aurora.cluster_engine
}

output "cluster_engine_version" {
  description = "The RDS cluster engine version"
  value       = module.rds_aurora.cluster_engine_version
}

output "cluster_engine_mode" {
  description = "The RDS cluster engine mode"
  value       = module.rds_aurora.cluster_engine_mode
}

output "cluster_storage_encrypted" {
  description = "The RDS cluster storage encrypted"
  value       = module.rds_aurora.cluster_storage_encrypted
}

output "cluster_kms_key_id" {
  description = "The RDS cluster KMS key ID"
  value       = module.rds_aurora.cluster_kms_key_id
}

output "cluster_deletion_protection" {
  description = "The RDS cluster deletion protection"
  value       = module.rds_aurora.cluster_deletion_protection
}

output "cluster_skip_final_snapshot" {
  description = "The RDS cluster skip final snapshot"
  value       = module.rds_aurora.cluster_skip_final_snapshot
}

output "cluster_final_snapshot_identifier" {
  description = "The RDS cluster final snapshot identifier"
  value       = module.rds_aurora.cluster_final_snapshot_identifier
}

output "cluster_instances" {
  description = "The RDS cluster instances"
  value       = module.rds_aurora.cluster_instances
}

output "cluster_instance_identifiers" {
  description = "The RDS cluster instance identifiers"
  value       = module.rds_aurora.cluster_instance_identifiers
}

output "cluster_instance_arns" {
  description = "The RDS cluster instance ARNs"
  value       = module.rds_aurora.cluster_instance_arns
}

output "cluster_instance_endpoints" {
  description = "The RDS cluster instance endpoints"
  value       = module.rds_aurora.cluster_instance_endpoints
}

output "cluster_instance_identifiers" {
  description = "The RDS cluster instance identifiers"
  value       = module.rds_aurora.cluster_instance_identifiers
}

output "cluster_instance_classes" {
  description = "The RDS cluster instance classes"
  value       = module.rds_aurora.cluster_instance_classes
}

output "cluster_instance_engine_versions" {
  description = "The RDS cluster instance engine versions"
  value       = module.rds_aurora.cluster_instance_engine_versions
}

output "cluster_instance_publicly_accessible" {
  description = "The RDS cluster instance publicly accessible"
  value       = module.rds_aurora.cluster_instance_publicly_accessible
}

output "cluster_instance_storage_encrypted" {
  description = "The RDS cluster instance storage encrypted"
  value       = module.rds_aurora.cluster_instance_storage_encrypted
}

output "cluster_instance_monitoring_interval" {
  description = "The RDS cluster instance monitoring interval"
  value       = module.rds_aurora.cluster_instance_monitoring_interval
}

output "cluster_instance_performance_insights_enabled" {
  description = "The RDS cluster instance performance insights enabled"
  value       = module.rds_aurora.cluster_instance_performance_insights_enabled
}

output "cluster_instance_performance_insights_retention_period" {
  description = "The RDS cluster instance performance insights retention period"
  value       = module.rds_aurora.cluster_instance_performance_insights_retention_period
}

output "cluster_instance_tags" {
  description = "The RDS cluster instance tags"
  value       = module.rds_aurora.cluster_instance_tags
}

output "cluster_tags" {
  description = "The RDS cluster tags"
  value       = module.rds_aurora.cluster_tags
}

output "db_subnet_group_id" {
  description = "The RDS DB subnet group ID"
  value       = module.rds_aurora.db_subnet_group_id
}

output "db_subnet_group_arn" {
  description = "The RDS DB subnet group ARN"
  value       = module.rds_aurora.db_subnet_group_arn
}

output "security_group_id" {
  description = "The RDS security group ID"
  value       = module.rds_aurora.security_group_id
}

output "security_group_arn" {
  description = "The RDS security group ARN"
  value       = module.rds_aurora.security_group_arn
}

output "security_group_ingress" {
  description = "The RDS security group ingress rules"
  value       = module.rds_aurora.security_group_ingress
}

output "security_group_egress" {
  description = "The RDS security group egress rules"
  value       = module.rds_aurora.security_group_egress
}

output "additional_cluster_parameter_group_ids" {
  description = "Map of additional cluster parameter group IDs"
  value       = { for k, v in aws_rds_cluster_parameter_group.additional : k => v.id }
}

output "additional_cluster_parameter_group_arns" {
  description = "Map of additional cluster parameter group ARNs"
  value       = { for k, v in aws_rds_cluster_parameter_group.additional : k => v.arn }
}

output "additional_instance_ids" {
  description = "Map of additional cluster instance IDs"
  value       = { for k, v in aws_rds_cluster_instance.additional : k => v.id }
}

output "additional_instance_arns" {
  description = "Map of additional cluster instance ARNs"
  value       = { for k, v in aws_rds_cluster_instance.additional : k => v.arn }
}
