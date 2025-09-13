# KMS Module - Outputs

output "key_id" {
  description = "ID of the KMS key"
  value       = module.kms.key_id
}

output "key_arn" {
  description = "ARN of the KMS key"
  value       = module.kms.key_arn
}

output "key_policy" {
  description = "Policy of the KMS key"
  value       = module.kms.key_policy
}

output "key_rotation_enabled" {
  description = "Whether key rotation is enabled"
  value       = module.kms.key_rotation_enabled
}

output "key_multi_region" {
  description = "Whether the key is multi-region"
  value       = module.kms.key_multi_region
}

output "key_deletion_window_in_days" {
  description = "Deletion window in days"
  value       = module.kms.key_deletion_window_in_days
}

output "key_description" {
  description = "Description of the KMS key"
  value       = module.kms.key_description
}

output "key_usage" {
  description = "Usage of the KMS key"
  value       = module.kms.key_usage
}

output "key_origin" {
  description = "Origin of the KMS key"
  value       = module.kms.key_origin
}

output "key_creation_date" {
  description = "Creation date of the KMS key"
  value       = module.kms.key_creation_date
}

output "key_enabled" {
  description = "Whether the KMS key is enabled"
  value       = module.kms.key_enabled
}

output "key_manager" {
  description = "Manager of the KMS key"
  value       = module.kms.key_manager
}

output "key_customer_master_key_spec" {
  description = "Customer master key spec of the KMS key"
  value       = module.kms.key_customer_master_key_spec
}

output "key_customer_master_key_spec_original" {
  description = "Original customer master key spec of the KMS key"
  value       = module.kms.key_customer_master_key_spec_original
}

output "key_aws_account_id" {
  description = "AWS account ID of the KMS key"
  value       = module.kms.key_aws_account_id
}

output "key_arn_old" {
  description = "Old ARN of the KMS key"
  value       = module.kms.key_arn_old
}

output "key_arn_new" {
  description = "New ARN of the KMS key"
  value       = module.kms.key_arn_new
}

output "key_arn_old_format" {
  description = "Old format ARN of the KMS key"
  value       = module.kms.key_arn_old_format
}

output "key_arn_new_format" {
  description = "New format ARN of the KMS key"
  value       = module.kms.key_arn_new_format
}

output "aliases" {
  description = "Map of KMS aliases"
  value       = module.kms.aliases
}

output "alias_arns" {
  description = "Map of KMS alias ARNs"
  value       = module.kms.alias_arns
}

output "alias_names" {
  description = "Map of KMS alias names"
  value       = module.kms.alias_names
}

output "alias_target_key_ids" {
  description = "Map of KMS alias target key IDs"
  value       = module.kms.alias_target_key_ids
}

output "grants" {
  description = "Map of KMS grants"
  value       = module.kms.grants
}

output "grant_tokens" {
  description = "Map of KMS grant tokens"
  value       = module.kms.grant_tokens
}

output "additional_keys" {
  description = "Map of additional KMS keys"
  value       = aws_kms_key.additional
}

output "additional_key_ids" {
  description = "Map of additional KMS key IDs"
  value       = { for k, v in aws_kms_key.additional : k => v.id }
}

output "additional_key_arns" {
  description = "Map of additional KMS key ARNs"
  value       = { for k, v in aws_kms_key.additional : k => v.arn }
}

output "additional_aliases" {
  description = "Map of additional KMS aliases"
  value       = aws_kms_alias.additional
}

output "additional_alias_arns" {
  description = "Map of additional KMS alias ARNs"
  value       = { for k, v in aws_kms_alias.additional : k => v.arn }
}

output "additional_grants" {
  description = "Map of additional KMS grants"
  value       = aws_kms_grant.additional
}

output "additional_grant_tokens" {
  description = "Map of additional KMS grant tokens"
  value       = { for k, v in aws_kms_grant.additional : k => v.grant_token }
}

output "additional_replica_keys" {
  description = "Map of additional KMS replica keys"
  value       = aws_kms_replica_key.additional
}

output "additional_replica_key_ids" {
  description = "Map of additional KMS replica key IDs"
  value       = { for k, v in aws_kms_replica_key.additional : k => v.id }
}

output "additional_replica_key_arns" {
  description = "Map of additional KMS replica key ARNs"
  value       = { for k, v in aws_kms_replica_key.additional : k => v.arn }
}

output "additional_external_keys" {
  description = "Map of additional KMS external keys"
  value       = aws_kms_external_key.additional
}

output "additional_external_key_ids" {
  description = "Map of additional KMS external key IDs"
  value       = { for k, v in aws_kms_external_key.additional : k => v.id }
}

output "additional_external_key_arns" {
  description = "Map of additional KMS external key ARNs"
  value       = { for k, v in aws_kms_external_key.additional : k => v.arn }
}
