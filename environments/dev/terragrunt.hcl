# Development environment configuration
include "root" {
  path = find_in_parent_folders()
}

# Configure the S3 backend for this environment
remote_state {
  backend = "s3"
  config = {
    bucket         = "terragrunt-${get_aws_account_id()}-state"
    key            = "dev/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Environment-specific inputs
inputs = {
  environment = "dev"
  
  # Development-specific settings
  instance_type = "t3.micro"
  min_size      = 1
  max_size      = 2
  
  # Enable additional logging and debugging
  enable_debug = true
}
