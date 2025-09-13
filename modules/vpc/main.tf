# VPC Module - Using official AWS VPC module from Terraform Registry

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "${var.environment}-vpc"
  cidr = var.cidr_block

  # Subnet configuration
  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  # NAT Gateway configuration
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  # DNS configuration
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags
  private_subnet_tags = merge(
    var.common_tags,
    {
      "Tier" = "private"
    }
  )

  public_subnet_tags = merge(
    var.common_tags,
    {
      "Tier" = "public"
    }
  )

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-vpc"
    }
  )

  # VPC Flow Logs
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  # VPC Endpoints
  enable_dhcp_options              = true
  dhcp_options_domain_name         = var.dhcp_domain_name
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

  # Default security group - restrict all traffic by default
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []
}
