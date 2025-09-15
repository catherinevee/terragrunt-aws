# S3 Module - Variables

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "object_lock_enabled" {
  description = "Indicates whether this bucket has an Object Lock configuration enabled"
  type        = bool
  default     = false
}

variable "object_lock_configuration" {
  description = "Object Lock configuration"
  type = object({
    object_lock_enabled = string
    rule = object({
      default_retention = object({
        mode = string
        days = number
      })
    })
  })
  default = null
}

variable "versioning_enabled" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = true
}

variable "mfa_delete_enabled" {
  description = "Enable MFA delete on the S3 bucket"
  type        = bool
  default     = false
}

variable "server_side_encryption_configuration" {
  description = "Server-side encryption configuration"
  type = object({
    rule = object({
      apply_server_side_encryption_by_default = object({
        sse_algorithm     = string
        kms_master_key_id = string
      })
      bucket_key_enabled = bool
    })
  })
  default = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "AES256"
        kms_master_key_id = null
      }
      bucket_key_enabled = true
    }
  }
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id      = string
    status  = string
    enabled = bool
    filter = object({
      prefix = string
      tags   = map(string)
    })
    expiration = object({
      days = number
    })
    noncurrent_version_expiration = object({
      noncurrent_days = number
    })
    transitions = list(object({
      days          = number
      storage_class = string
    }))
    noncurrent_version_transitions = list(object({
      noncurrent_days = number
      storage_class   = string
    }))
  }))
  default = []
}

variable "intelligent_tiering" {
  description = "Map of intelligent tiering configurations"
  type = map(object({
    status = string
    filter = object({
      prefix = string
      tags   = map(string)
    })
    tiering = object({
      archive_access_tier_days      = number
      deep_archive_access_tier_days = number
    })
  }))
  default = {}
}

variable "logging" {
  description = "Logging configuration"
  type = object({
    target_bucket = string
    target_prefix = string
  })
  default = {}
}

variable "replication_configuration" {
  description = "Replication configuration"
  type = object({
    role = string
    rules = list(object({
      id     = string
      status = string
      filter = object({
        prefix = string
        tags   = map(string)
      })
      destination = object({
        bucket             = string
        storage_class      = string
        replica_kms_key_id = string
        account_id         = string
        access_control_translation = object({
          owner = string
        })
        metrics = object({
          status = string
        })
      })
    }))
  })
  default = {}
}

variable "notification" {
  description = "Notification configuration"
  type = object({
    lambda_functions = list(object({
      lambda_function_arn = string
      events              = list(string)
      filter_prefix       = string
      filter_suffix       = string
    }))
    sqs = list(object({
      queue_arn     = string
      events        = list(string)
      filter_prefix = string
      filter_suffix = string
    }))
    sns = list(object({
      topic_arn     = string
      events        = list(string)
      filter_prefix = string
      filter_suffix = string
    }))
  })
  default = null
}

variable "website" {
  description = "Website configuration"
  type = object({
    index_document = string
    error_document = string
    routing_rules  = string
  })
  default = {}
}

variable "cors_rule" {
  description = "CORS configuration"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = []
}

variable "bucket_policies" {
  description = "Map of bucket policies to attach"
  type        = map(string)
  default     = {}
}

variable "additional_buckets" {
  description = "Map of additional S3 buckets to create"
  type = map(object({
    force_destroy      = bool
    versioning_enabled = bool
  }))
  default = {}
}

variable "additional_bucket_policies" {
  description = "Map of additional bucket policies to attach"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}