# KMS Module - Variables

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "name" {
  description = "Name of the KMS key"
  type        = string
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
  default     = "KMS key managed by Terraform"
}

variable "deletion_window_in_days" {
  description = "Deletion window in days for the KMS key"
  type        = number
  default     = 7
}

variable "enable_key_rotation" {
  description = "Enable automatic key rotation"
  type        = bool
  default     = true
}

variable "policy" {
  description = "Policy document for the KMS key"
  type        = string
  default     = null
}

variable "multi_region" {
  description = "Whether the key is multi-region"
  type        = bool
  default     = false
}

variable "aliases" {
  description = "Map of KMS aliases to create"
  type = map(object({
    name = string
  }))
  default = {}
}

variable "key_policy" {
  description = "Key policy for the KMS key"
  type        = string
  default     = null
}

variable "grants" {
  description = "Map of KMS grants to create"
  type = map(object({
    name = string
    key_id = string
    grantee_principal = string
    operations = list(string)
    constraints = object({
      encryption_context_equals = map(string)
      encryption_context_subset = map(string)
    })
  }))
  default = {}
}

variable "additional_keys" {
  description = "Map of additional KMS keys to create"
  type = map(object({
    description = string
    deletion_window_in_days = number
    enable_key_rotation = bool
    policy = string
    multi_region = bool
  }))
  default = {}
}

variable "additional_aliases" {
  description = "Map of additional KMS aliases to create"
  type = map(object({
    target_key_id = string
  }))
  default = {}
}

variable "additional_grants" {
  description = "Map of additional KMS grants to create"
  type = map(object({
    key_id = string
    grantee_principal = string
    operations = list(string)
    constraints = object({
      encryption_context_equals = map(string)
      encryption_context_subset = map(string)
    })
  }))
  default = {}
}

variable "additional_replica_keys" {
  description = "Map of additional KMS replica keys to create"
  type = map(object({
    description = string
    primary_key_arn = string
    policy = string
  }))
  default = {}
}

variable "additional_external_keys" {
  description = "Map of additional KMS external keys to create"
  type = map(object({
    description = string
    deletion_window_in_days = number
    policy = string
    key_material_base64 = string
    valid_to = string
  }))
  default = {}
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
