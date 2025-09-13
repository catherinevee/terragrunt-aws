# Terragrunt configuration for the entire repository
# This file is loaded for all environments and regions

# Configure Terragrunt to use a shorter cache directory to avoid Windows path length issues
# This is set via environment variable or terragrunt command line

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

# Backend configuration is managed by individual environment terragrunt.hcl files
# This allows each environment to have its own S3 bucket and DynamoDB table
