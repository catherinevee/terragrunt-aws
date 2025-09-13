# S3 Module - Outputs

output "s3_bucket_id" {
  description = "The name of the bucket"
  value       = module.s3_bucket.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket"
  value       = module.s3_bucket.s3_bucket_arn
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name"
  value       = module.s3_bucket.s3_bucket_bucket_domain_name
}

output "s3_bucket_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name"
  value       = module.s3_bucket.s3_bucket_bucket_regional_domain_name
}

output "s3_bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region"
  value       = module.s3_bucket.s3_bucket_hosted_zone_id
}

output "s3_bucket_region" {
  description = "The AWS region this bucket resides in"
  value       = module.s3_bucket.s3_bucket_region
}

output "s3_bucket_website_endpoint" {
  description = "The website endpoint"
  value       = module.s3_bucket.s3_bucket_website_endpoint
}

output "s3_bucket_website_domain" {
  description = "The website domain"
  value       = module.s3_bucket.s3_bucket_website_domain
}

output "s3_bucket_versioning_id" {
  description = "The versioning state of the bucket"
  value       = module.s3_bucket.s3_bucket_versioning_id
}

output "s3_bucket_versioning_enabled" {
  description = "Whether versioning is enabled"
  value       = module.s3_bucket.s3_bucket_versioning_enabled
}

output "s3_bucket_server_side_encryption_configuration_id" {
  description = "The server-side encryption configuration ID"
  value       = module.s3_bucket.s3_bucket_server_side_encryption_configuration_id
}

output "s3_bucket_public_access_block_id" {
  description = "The public access block ID"
  value       = module.s3_bucket.s3_bucket_public_access_block_id
}

output "s3_bucket_lifecycle_configuration_id" {
  description = "The lifecycle configuration ID"
  value       = module.s3_bucket.s3_bucket_lifecycle_configuration_id
}

output "s3_bucket_intelligent_tiering_configuration_id" {
  description = "The intelligent tiering configuration ID"
  value       = module.s3_bucket.s3_bucket_intelligent_tiering_configuration_id
}

output "s3_bucket_logging_id" {
  description = "The logging configuration ID"
  value       = module.s3_bucket.s3_bucket_logging_id
}

output "s3_bucket_replication_configuration_id" {
  description = "The replication configuration ID"
  value       = module.s3_bucket.s3_bucket_replication_configuration_id
}

output "s3_bucket_notification_id" {
  description = "The notification configuration ID"
  value       = module.s3_bucket.s3_bucket_notification_id
}

output "s3_bucket_website_configuration_id" {
  description = "The website configuration ID"
  value       = module.s3_bucket.s3_bucket_website_configuration_id
}

output "s3_bucket_cors_configuration_id" {
  description = "The CORS configuration ID"
  value       = module.s3_bucket.s3_bucket_cors_configuration_id
}

output "s3_bucket_policy_id" {
  description = "The bucket policy ID"
  value       = module.s3_bucket.s3_bucket_policy_id
}

output "additional_bucket_ids" {
  description = "Map of additional bucket IDs"
  value       = { for k, v in aws_s3_bucket.additional : k => v.id }
}

output "additional_bucket_arns" {
  description = "Map of additional bucket ARNs"
  value       = { for k, v in aws_s3_bucket.additional : k => v.arn }
}

output "additional_bucket_domain_names" {
  description = "Map of additional bucket domain names"
  value       = { for k, v in aws_s3_bucket.additional : k => v.bucket_domain_name }
}

output "additional_bucket_regional_domain_names" {
  description = "Map of additional bucket regional domain names"
  value       = { for k, v in aws_s3_bucket.additional : k => v.bucket_regional_domain_name }
}

output "additional_bucket_hosted_zone_ids" {
  description = "Map of additional bucket hosted zone IDs"
  value       = { for k, v in aws_s3_bucket.additional : k => v.hosted_zone_id }
}

output "additional_bucket_regions" {
  description = "Map of additional bucket regions"
  value       = { for k, v in aws_s3_bucket.additional : k => v.region }
}

output "bucket_suffix" {
  description = "Random suffix used for bucket naming"
  value       = random_string.bucket_suffix.result
}

output "additional_bucket_suffixes" {
  description = "Map of additional bucket suffixes"
  value       = { for k, v in random_string.additional_bucket_suffix : k => v.result }
}
