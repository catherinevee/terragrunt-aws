# Production environment configuration
include "root" {
  path = find_in_parent_folders()
}

# Configure the S3 backend for this environment
remote_state {
  backend = "s3"
  config = {
    bucket         = "terragrunt-${get_aws_account_id()}-state"
    key            = "prod/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Environment-specific inputs
inputs = {
  environment = "prod"
  
  # Production-specific settings
  instance_type = "m5.large"
  min_size      = 3
  max_size      = 10
  
  # Enable all monitoring and security features
  enable_monitoring      = true
  enable_enhanced_security = true
  enable_cloudtrail      = true
  enable_guardduty       = true
  enable_security_hub    = true
  
  # Multi-AZ for high availability
  multi_az = true
  
  # Enable backup and disaster recovery
  enable_backup = true
  backup_retention_days = 30
}
