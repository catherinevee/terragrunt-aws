# VPC configuration for prod environment in eu-west-1

# Include the root configuration
include "root" {
  path = find_in_parent_folders()
}

# Environment configuration is included in the root terragrunt.hcl

# Configure the S3 backend for this component
remote_state {
  backend = "s3"
  config = {
    bucket         = "terragrunt-${get_aws_account_id()}-state-eu-west-1-20250913095334"
    key            = "prod/eu-west-1/vpc/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-locks-eu-west-1-20250913095334"
  }
}

# Define the Terraform module to use
terraform {
  source = "../../../..//modules/vpc"
}

# Define input variables for the VPC module
inputs = {
  environment = "prod"
  region     = "eu-west-1"
  cidr_block = "10.3.0.0/16"
  
  public_subnet_cidrs = [
    "10.3.1.0/24",
    "10.3.2.0/24",
    "10.3.3.0/24"
  ]
  
  private_subnet_cidrs = [
    "10.3.101.0/24",
    "10.3.102.0/24",
    "10.3.103.0/24"
  ]
  
  availability_zones = [
    "eu-west-1a",
    "eu-west-1b",
    "eu-west-1c"
  ]
  
  # NAT Gateway configuration
  enable_nat_gateway     = false  # Disable NAT Gateway to avoid EIP limit issues
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  
  # VPC Endpoints
  enable_s3_endpoint = true
  
  # Common tags
  common_tags = {
    Environment = "prod"
    Terraform   = "true"
    ManagedBy   = "terragrunt"
    Project     = "terragrunt-aws"
  }
  
  # Additional tags for resources
  vpc_tags = {
    Name = "prod-vpc"
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
  dhcp_domain_name = "prod.internal"
}