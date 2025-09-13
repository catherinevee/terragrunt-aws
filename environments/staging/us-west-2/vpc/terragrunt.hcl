# VPC configuration for staging environment in us-west-2

# Include the root configuration
include "root" {
  path = find_in_parent_folders()
}

# Environment configuration is included in the root terragrunt.hcl

# Configure the S3 backend for this component
remote_state {
  backend = "s3"
  config = {
    bucket         = "terragrunt-${get_aws_account_id()}-state-us-west-2"
    key            = "staging/us-west-2/vpc/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Define the Terraform module to use
terraform {
  source = "../../../..//modules/vpc"
}

# Define input variables for the VPC module
inputs = {
  environment = "staging"
  region     = "us-west-2"
  cidr_block = "10.2.0.0/16"
  
  public_subnet_cidrs = [
    "10.2.1.0/24",
    "10.2.2.0/24",
    "10.2.3.0/24"
  ]
  
  private_subnet_cidrs = [
    "10.2.101.0/24",
    "10.2.102.0/24",
    "10.2.103.0/24"
  ]
  
  availability_zones = [
    "us-west-2a",
    "us-west-2b",
    "us-west-2c"
  ]
  
  # NAT Gateway configuration
  enable_nat_gateway     = true
  single_nat_gateway     = false  # Use multiple NAT Gateways for better availability in staging
  one_nat_gateway_per_az = true
  
  # VPC Endpoints
  enable_s3_endpoint = true
  
  # Common tags
  common_tags = {
    Environment = "staging"
    Terraform   = "true"
    ManagedBy   = "terragrunt"
    Project     = "terragrunt-aws"
  }
  
  # Additional tags for resources
  vpc_tags = {
    Name = "staging-vpc"
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
  dhcp_domain_name = "staging.internal"
}