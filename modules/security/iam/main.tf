# IAM Module - Using official AWS IAM module from Terraform Registry

module "iam" {
  source  = "terraform-aws-modules/iam/aws"
  version = "~> 5.0"

  # IAM Users
  users = var.users

  # IAM Groups
  groups = var.groups

  # IAM Roles
  roles = var.roles

  # IAM Policies
  policies = var.policies

  # IAM Policy Attachments
  user_policy_attachments  = var.user_policy_attachments
  group_policy_attachments = var.group_policy_attachments
  role_policy_attachments  = var.role_policy_attachments

  # IAM Group Memberships
  group_memberships = var.group_memberships

  # IAM Instance Profiles
  instance_profiles = var.instance_profiles

  # IAM OpenID Connect Providers
  oidc_providers = var.oidc_providers

  # IAM SAML Providers
  saml_providers = var.saml_providers

  # IAM Account Aliases
  account_aliases = var.account_aliases

  # IAM Account Password Policy
  account_password_policy = var.account_password_policy

  # IAM Access Analyzer
  access_analyzer = var.access_analyzer

  # IAM Organizations
  organizations = var.organizations

  # IAM Service Linked Roles
  service_linked_roles = var.service_linked_roles

  # Tags
  tags = merge(
    var.common_tags,
    {
      Type = "iam"
    }
  )
}

# Additional IAM resources
resource "aws_iam_user" "additional" {
  for_each = var.additional_users

  name = each.key
  path = each.value.path

  force_destroy = each.value.force_destroy

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "iam-user"
    }
  )
}

resource "aws_iam_group" "additional" {
  for_each = var.additional_groups

  name = each.key
  path = each.value.path

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "iam-group"
    }
  )
}

resource "aws_iam_role" "additional" {
  for_each = var.additional_roles

  name = each.key
  path = each.value.path

  assume_role_policy = each.value.assume_role_policy

  max_session_duration = each.value.max_session_duration
  permissions_boundary = each.value.permissions_boundary

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "iam-role"
    }
  )
}

resource "aws_iam_policy" "additional" {
  for_each = var.additional_policies

  name        = each.key
  path        = each.value.path
  description = each.value.description
  policy      = each.value.policy

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "iam-policy"
    }
  )
}

resource "aws_iam_policy_attachment" "additional" {
  for_each = var.additional_policy_attachments

  name       = each.key
  users      = each.value.users
  groups     = each.value.groups
  roles      = each.value.roles
  policy_arn = each.value.policy_arn
}

resource "aws_iam_user_group_membership" "additional" {
  for_each = var.additional_group_memberships

  user   = each.value.user
  groups = each.value.groups
}

resource "aws_iam_instance_profile" "additional" {
  for_each = var.additional_instance_profiles

  name = each.key
  path = each.value.path
  role = each.value.role

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "iam-instance-profile"
    }
  )
}

# IAM Access Keys
resource "aws_iam_access_key" "additional" {
  for_each = var.additional_access_keys

  user    = each.value.user
  pgp_key = each.value.pgp_key
  status  = each.value.status
}

# IAM User Login Profiles
resource "aws_iam_user_login_profile" "additional" {
  for_each = var.additional_login_profiles

  user                    = each.value.user
  pgp_key                 = each.value.pgp_key
  password_reset_required = each.value.password_reset_required
  password_length         = each.value.password_length
}

# IAM Service Specific Credentials
resource "aws_iam_service_specific_credential" "additional" {
  for_each = var.additional_service_credentials

  service_name = each.value.service_name
  user_name    = each.value.user_name
  status       = each.value.status
}

# IAM Virtual MFA Devices
resource "aws_iam_virtual_mfa_device" "additional" {
  for_each = var.additional_virtual_mfa_devices

  virtual_mfa_device_name = each.key
  path                    = each.value.path

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "iam-virtual-mfa-device"
    }
  )
}
