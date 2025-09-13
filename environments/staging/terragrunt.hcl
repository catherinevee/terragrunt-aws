# Staging environment configuration
include "root" {
  path = find_in_parent_folders()
}

# Configure the S3 backend for this environment
remote_state {
  backend = "s3"
  config = {
    bucket         = "terragrunt-${get_aws_account_id()}-state"
    key            = "staging/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Environment-specific inputs
inputs = {
  environment = "staging"
  
  # Staging-specific settings
  instance_type = "t3.medium"
  min_size      = 2
  max_size      = 4
  
  # Enable additional monitoring
  enable_monitoring = true
  
  # More restrictive security settings than dev
  enable_enhanced_security = true
}
