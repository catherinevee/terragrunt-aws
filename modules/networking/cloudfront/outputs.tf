# CloudFront Module - Outputs

output "distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.cloudfront.distribution_id
}

output "distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = module.cloudfront.distribution_arn
}

output "distribution_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = module.cloudfront.distribution_domain_name
}

output "distribution_hosted_zone_id" {
  description = "Hosted zone ID of the CloudFront distribution"
  value       = module.cloudfront.distribution_hosted_zone_id
}

output "distribution_status" {
  description = "Status of the CloudFront distribution"
  value       = module.cloudfront.distribution_status
}

output "distribution_in_progress_validation_batches" {
  description = "Number of in-progress validation batches"
  value       = module.cloudfront.distribution_in_progress_validation_batches
}

output "distribution_last_modified_time" {
  description = "Last modified time of the CloudFront distribution"
  value       = module.cloudfront.distribution_last_modified_time
}

output "distribution_etag" {
  description = "ETag of the CloudFront distribution"
  value       = module.cloudfront.distribution_etag
}

output "distribution_tags_all" {
  description = "All tags of the CloudFront distribution"
  value       = module.cloudfront.distribution_tags_all
}

output "additional_distributions" {
  description = "Map of additional CloudFront distributions"
  value       = aws_cloudfront_distribution.additional
}

output "additional_distribution_ids" {
  description = "Map of additional CloudFront distribution IDs"
  value       = { for k, v in aws_cloudfront_distribution.additional : k => v.id }
}

output "additional_distribution_arns" {
  description = "Map of additional CloudFront distribution ARNs"
  value       = { for k, v in aws_cloudfront_distribution.additional : k => v.arn }
}

output "additional_distribution_domain_names" {
  description = "Map of additional CloudFront distribution domain names"
  value       = { for k, v in aws_cloudfront_distribution.additional : k => v.domain_name }
}

output "additional_distribution_hosted_zone_ids" {
  description = "Map of additional CloudFront distribution hosted zone IDs"
  value       = { for k, v in aws_cloudfront_distribution.additional : k => v.hosted_zone_id }
}

output "additional_distribution_statuses" {
  description = "Map of additional CloudFront distribution statuses"
  value       = { for k, v in aws_cloudfront_distribution.additional : k => v.status }
}
