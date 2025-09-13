# Terragrunt configuration for the entire repository
# This file is loaded for all environments and regions

# Configure Terragrunt to use DynamoDB for state locking

# Generate provider configuration for all modules
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${get_env("AWS_REGION", "us-east-1")}"
  
  # Assume role for cross-account access if needed
  # assume_role {
  #   role_arn = "arn:aws:iam::${get_aws_account_id()}:role/OrganizationAccountAccessRole"
  # }
  
  # Enable AWS provider version 5.0 or later
  version = ">= 5.0.0"
  
  # Default tags to be applied to all resources
  default_tags {
    tags = {
      Environment = "${get_env("ENVIRONMENT", "dev")}"
      ManagedBy   = "terragrunt"
      Repository  = "terragrunt-aws"
      Terraform   = "true"
    }
  }
}

# Required provider versions
terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
EOF
}

# Configure input variables that are common across all environments
inputs = {
  environment = get_env("ENVIRONMENT", "dev")
  region     = get_env("AWS_REGION", "us-east-1")
  
  # Common tags to be applied to all resources
  common_tags = {
    Environment = get_env("ENVIRONMENT", "dev")
    ManagedBy   = "terragrunt"
    Repository  = "terragrunt-aws"
    Terraform   = "true"
    Owner       = "platform-team"
    Project     = "terragrunt-aws"
  }
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "${get_env("TF_STATE_BUCKET", "terragrunt-${get_aws_account_id()}-state")}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = get_env("AWS_REGION", "us-east-1")
    encrypt        = true
    dynamodb_table = "terraform-locks"
    
    s3_bucket_tags = {
      Environment = get_env("ENVIRONMENT", "dev")
      ManagedBy   = "terragrunt"
      Repository  = "terragrunt-aws"
    }
  }
}
