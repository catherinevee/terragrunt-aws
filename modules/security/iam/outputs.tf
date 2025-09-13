# IAM Module - Outputs

# Users
output "iam_users" {
  description = "Map of IAM users"
  value       = module.iam.iam_users
}

output "iam_user_arns" {
  description = "Map of IAM user ARNs"
  value       = module.iam.iam_user_arns
}

output "iam_user_names" {
  description = "Map of IAM user names"
  value       = module.iam.iam_user_names
}

output "iam_user_unique_ids" {
  description = "Map of IAM user unique IDs"
  value       = module.iam.iam_user_unique_ids
}

# Groups
output "iam_groups" {
  description = "Map of IAM groups"
  value       = module.iam.iam_groups
}

output "iam_group_arns" {
  description = "Map of IAM group ARNs"
  value       = module.iam.iam_group_arns
}

output "iam_group_names" {
  description = "Map of IAM group names"
  value       = module.iam.iam_group_names
}

output "iam_group_unique_ids" {
  description = "Map of IAM group unique IDs"
  value       = module.iam.iam_group_unique_ids
}

# Roles
output "iam_roles" {
  description = "Map of IAM roles"
  value       = module.iam.iam_roles
}

output "iam_role_arns" {
  description = "Map of IAM role ARNs"
  value       = module.iam.iam_role_arns
}

output "iam_role_names" {
  description = "Map of IAM role names"
  value       = module.iam.iam_role_names
}

output "iam_role_unique_ids" {
  description = "Map of IAM role unique IDs"
  value       = module.iam.iam_role_unique_ids
}

# Policies
output "iam_policies" {
  description = "Map of IAM policies"
  value       = module.iam.iam_policies
}

output "iam_policy_arns" {
  description = "Map of IAM policy ARNs"
  value       = module.iam.iam_policy_arns
}

output "iam_policy_names" {
  description = "Map of IAM policy names"
  value       = module.iam.iam_policy_names
}

output "iam_policy_ids" {
  description = "Map of IAM policy IDs"
  value       = module.iam.iam_policy_ids
}

# Instance Profiles
output "iam_instance_profiles" {
  description = "Map of IAM instance profiles"
  value       = module.iam.iam_instance_profiles
}

output "iam_instance_profile_arns" {
  description = "Map of IAM instance profile ARNs"
  value       = module.iam.iam_instance_profile_arns
}

output "iam_instance_profile_names" {
  description = "Map of IAM instance profile names"
  value       = module.iam.iam_instance_profile_names
}

output "iam_instance_profile_unique_ids" {
  description = "Map of IAM instance profile unique IDs"
  value       = module.iam.iam_instance_profile_unique_ids
}

# OIDC Providers
output "iam_oidc_providers" {
  description = "Map of IAM OIDC providers"
  value       = module.iam.iam_oidc_providers
}

output "iam_oidc_provider_arns" {
  description = "Map of IAM OIDC provider ARNs"
  value       = module.iam.iam_oidc_provider_arns
}

# SAML Providers
output "iam_saml_providers" {
  description = "Map of IAM SAML providers"
  value       = module.iam.iam_saml_providers
}

output "iam_saml_provider_arns" {
  description = "Map of IAM SAML provider ARNs"
  value       = module.iam.iam_saml_provider_arns
}

# Account Aliases
output "iam_account_alias" {
  description = "IAM account alias"
  value       = module.iam.iam_account_alias
}

# Password Policy
output "iam_account_password_policy" {
  description = "IAM account password policy"
  value       = module.iam.iam_account_password_policy
}

# Access Analyzer
output "iam_access_analyzer" {
  description = "IAM access analyzer"
  value       = module.iam.iam_access_analyzer
}

output "iam_access_analyzer_arn" {
  description = "IAM access analyzer ARN"
  value       = module.iam.iam_access_analyzer_arn
}

# Organizations
output "iam_organizations" {
  description = "Map of IAM organizations"
  value       = module.iam.iam_organizations
}

output "iam_organization_arns" {
  description = "Map of IAM organization ARNs"
  value       = module.iam.iam_organization_arns
}

# Service Linked Roles
output "iam_service_linked_roles" {
  description = "Map of IAM service linked roles"
  value       = module.iam.iam_service_linked_roles
}

output "iam_service_linked_role_arns" {
  description = "Map of IAM service linked role ARNs"
  value       = module.iam.iam_service_linked_role_arns
}

# Additional Resources
output "additional_users" {
  description = "Map of additional IAM users"
  value       = aws_iam_user.additional
}

output "additional_user_arns" {
  description = "Map of additional IAM user ARNs"
  value       = { for k, v in aws_iam_user.additional : k => v.arn }
}

output "additional_groups" {
  description = "Map of additional IAM groups"
  value       = aws_iam_group.additional
}

output "additional_group_arns" {
  description = "Map of additional IAM group ARNs"
  value       = { for k, v in aws_iam_group.additional : k => v.arn }
}

output "additional_roles" {
  description = "Map of additional IAM roles"
  value       = aws_iam_role.additional
}

output "additional_role_arns" {
  description = "Map of additional IAM role ARNs"
  value       = { for k, v in aws_iam_role.additional : k => v.arn }
}

output "additional_policies" {
  description = "Map of additional IAM policies"
  value       = aws_iam_policy.additional
}

output "additional_policy_arns" {
  description = "Map of additional IAM policy ARNs"
  value       = { for k, v in aws_iam_policy.additional : k => v.arn }
}

output "additional_instance_profiles" {
  description = "Map of additional IAM instance profiles"
  value       = aws_iam_instance_profile.additional
}

output "additional_instance_profile_arns" {
  description = "Map of additional IAM instance profile ARNs"
  value       = { for k, v in aws_iam_instance_profile.additional : k => v.arn }
}

output "additional_access_keys" {
  description = "Map of additional IAM access keys"
  value       = aws_iam_access_key.additional
}

output "additional_access_key_ids" {
  description = "Map of additional IAM access key IDs"
  value       = { for k, v in aws_iam_access_key.additional : k => v.id }
}

output "additional_access_key_secrets" {
  description = "Map of additional IAM access key secrets"
  value       = { for k, v in aws_iam_access_key.additional : k => v.secret }
  sensitive   = true
}

output "additional_login_profiles" {
  description = "Map of additional IAM user login profiles"
  value       = aws_iam_user_login_profile.additional
}

output "additional_service_credentials" {
  description = "Map of additional IAM service specific credentials"
  value       = aws_iam_service_specific_credential.additional
}

output "additional_virtual_mfa_devices" {
  description = "Map of additional IAM virtual MFA devices"
  value       = aws_iam_virtual_mfa_device.additional
}
