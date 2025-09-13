# KMS configuration for dev environment in us-east-1

# Include the root configuration
include "root" {
  path = find_in_parent_folders()
}

# Include the environment configuration
include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

# Configure the S3 backend for this component
remote_state {
  backend = "s3"
  config = {
    bucket         = "terragrunt-${get_aws_account_id()}-state"
    key            = "dev/us-east-1/kms/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Define the Terraform module to use
terraform {
  source = "../../../..//modules/security/kms"
}

# Define input variables for the KMS module
inputs = {
  environment = "dev"
  name        = "main"
  region      = "us-east-1"
  
  # KMS Key configuration
  description = "KMS key for dev environment"
  deletion_window_in_days = 7
  enable_key_rotation = true
  multi_region = false
  
  # KMS Aliases
  aliases = {
    "alias/dev-main" = {
      name = "alias/dev-main"
    }
  }
  
  # Key policy
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${get_aws_account_id()}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudTrail to encrypt logs"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey*"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:EncryptionContext:aws:cloudtrail:arn" = "arn:aws:cloudtrail:us-east-1:${get_aws_account_id()}:trail/*"
          }
        }
      }
    ]
  })
  
  # Common tags
  common_tags = {
    Environment = "dev"
    Terraform   = "true"
    ManagedBy   = "terragrunt"
    Project     = "terragrunt-aws"
  }
}
