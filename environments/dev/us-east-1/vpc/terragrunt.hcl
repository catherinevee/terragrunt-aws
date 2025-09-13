# VPC configuration for dev environment in us-east-1
# Backend configuration fixed - ready for deployment - CI/CD Test

# Include the root configuration
include "root" {
  path = find_in_parent_folders()
}

# Configure the S3 backend for this component
remote_state {
  backend = "s3"
  config = {
    bucket         = "terragrunt-${get_aws_account_id()}-state-us-east-1-20250913095334"
    key            = "dev/us-east-1/vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks-us-east-1-20250913095334"
  }
}

# Define the Terraform module to use
terraform {
  source = "../../../..//modules/vpc"
}

# Define input variables for the VPC module
inputs = {
  environment = "dev"
  region     = "us-east-1"
  cidr_block = "10.1.0.0/16"
  
  public_subnet_cidrs = [
    "10.1.1.0/24",
    "10.1.2.0/24",
    "10.1.3.0/24"
  ]
  
  private_subnet_cidrs = [
    "10.1.101.0/24",
    "10.1.102.0/24",
    "10.1.103.0/24"
  ]
  
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
  
  # NAT Gateway configuration
  enable_nat_gateway     = false  # Disable NAT Gateway to avoid EIP limit issues
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  
  # VPC Endpoints
  enable_s3_endpoint = true
  
  # Common tags
  common_tags = {
    Environment = "dev"
    Terraform   = "true"
    ManagedBy   = "terragrunt"
    Project     = "terragrunt-aws"
  }
  
  # Additional tags for resources
  vpc_tags = {
    Name = "dev-vpc"
  }
  
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
  
  # Flow Logs
  enable_flow_log = true
  flow_log_traffic_type = "ALL"
  
  # DHCP Options
  dhcp_domain_name = "dev.internal"
}