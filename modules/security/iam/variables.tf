# IAM Module - Variables

variable "users" {
  description = "Map of IAM users to create"
  type = map(object({
    path                 = string
    force_destroy        = bool
    permissions_boundary = string
    tags                 = map(string)
  }))
  default = {}
}

variable "groups" {
  description = "Map of IAM groups to create"
  type = map(object({
    path = string
    tags = map(string)
  }))
  default = {}
}

variable "roles" {
  description = "Map of IAM roles to create"
  type = map(object({
    path                 = string
    assume_role_policy   = string
    max_session_duration = number
    permissions_boundary = string
    tags                 = map(string)
  }))
  default = {}
}

variable "policies" {
  description = "Map of IAM policies to create"
  type = map(object({
    path        = string
    description = string
    policy      = string
    tags        = map(string)
  }))
  default = {}
}

variable "user_policy_attachments" {
  description = "Map of user policy attachments"
  type = map(object({
    users      = list(string)
    policy_arn = string
  }))
  default = {}
}

variable "group_policy_attachments" {
  description = "Map of group policy attachments"
  type = map(object({
    groups     = list(string)
    policy_arn = string
  }))
  default = {}
}

variable "role_policy_attachments" {
  description = "Map of role policy attachments"
  type = map(object({
    roles      = list(string)
    policy_arn = string
  }))
  default = {}
}

variable "group_memberships" {
  description = "Map of group memberships"
  type = map(object({
    users  = list(string)
    groups = list(string)
  }))
  default = {}
}

variable "instance_profiles" {
  description = "Map of IAM instance profiles to create"
  type = map(object({
    path = string
    role = string
    tags = map(string)
  }))
  default = {}
}

variable "oidc_providers" {
  description = "Map of OIDC providers to create"
  type = map(object({
    url             = string
    client_id_list  = list(string)
    thumbprint_list = list(string)
    tags            = map(string)
  }))
  default = {}
}

variable "saml_providers" {
  description = "Map of SAML providers to create"
  type = map(object({
    name                   = string
    saml_metadata_document = string
    tags                   = map(string)
  }))
  default = {}
}

variable "account_aliases" {
  description = "List of account aliases"
  type        = list(string)
  default     = []
}

variable "account_password_policy" {
  description = "Account password policy configuration"
  type = object({
    minimum_password_length        = number
    require_lowercase_characters   = bool
    require_uppercase_characters   = bool
    require_numbers                = bool
    require_symbols                = bool
    allow_users_to_change_password = bool
    max_password_age               = number
    password_reuse_prevention      = number
    hard_expiry                    = bool
  })
  default = null
}

variable "access_analyzer" {
  description = "Access Analyzer configuration"
  type = object({
    analyzer_name = string
    type          = string
    tags          = map(string)
  })
  default = null
}

variable "organizations" {
  description = "Map of organizations to create"
  type = map(object({
    feature_set                   = string
    aws_service_access_principals = list(string)
    enabled_policy_types          = list(string)
    tags                          = map(string)
  }))
  default = {}
}

variable "service_linked_roles" {
  description = "Map of service linked roles to create"
  type = map(object({
    aws_service_name = string
    description      = string
    custom_suffix    = string
    tags             = map(string)
  }))
  default = {}
}

variable "additional_users" {
  description = "Map of additional IAM users to create"
  type = map(object({
    path                 = string
    force_destroy        = bool
    permissions_boundary = string
  }))
  default = {}
}

variable "additional_groups" {
  description = "Map of additional IAM groups to create"
  type = map(object({
    path = string
  }))
  default = {}
}

variable "additional_roles" {
  description = "Map of additional IAM roles to create"
  type = map(object({
    path                 = string
    assume_role_policy   = string
    max_session_duration = number
    permissions_boundary = string
  }))
  default = {}
}

variable "additional_policies" {
  description = "Map of additional IAM policies to create"
  type = map(object({
    path        = string
    description = string
    policy      = string
  }))
  default = {}
}

variable "additional_policy_attachments" {
  description = "Map of additional policy attachments"
  type = map(object({
    users      = list(string)
    groups     = list(string)
    roles      = list(string)
    policy_arn = string
  }))
  default = {}
}

variable "additional_group_memberships" {
  description = "Map of additional group memberships"
  type = map(object({
    user   = string
    groups = list(string)
  }))
  default = {}
}

variable "additional_instance_profiles" {
  description = "Map of additional IAM instance profiles to create"
  type = map(object({
    path = string
    role = string
  }))
  default = {}
}

variable "additional_access_keys" {
  description = "Map of additional IAM access keys to create"
  type = map(object({
    user    = string
    pgp_key = string
    status  = string
  }))
  default = {}
}

variable "additional_login_profiles" {
  description = "Map of additional IAM user login profiles to create"
  type = map(object({
    user                    = string
    pgp_key                 = string
    password_reset_required = bool
    password_length         = number
  }))
  default = {}
}

variable "additional_service_credentials" {
  description = "Map of additional IAM service specific credentials to create"
  type = map(object({
    service_name = string
    user_name    = string
    status       = string
  }))
  default = {}
}

variable "additional_virtual_mfa_devices" {
  description = "Map of additional IAM virtual MFA devices to create"
  type = map(object({
    path = string
  }))
  default = {}
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
