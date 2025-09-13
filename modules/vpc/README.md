# VPC Module

This module creates a VPC with public and private subnets, NAT Gateway, and route tables using the official AWS VPC module from Terraform Registry.

## Features

- VPC with configurable CIDR blocks
- Public and private subnets across multiple AZs
- Internet Gateway for public subnets
- NAT Gateway for private subnets
- Route tables and associations
- VPC Flow Logs
- VPC Endpoints (S3, SSM, EC2 Messages, SSM Messages)
- DHCP Options Set

## Usage

```hcl
module "vpc" {
  source = "../../modules/vpc"
  
  environment = "dev"
  cidr_block = "10.0.0.0/16"
  
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
  
  enable_nat_gateway = true
  single_nat_gateway = true
  
  common_tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | The environment name | `string` | n/a | yes |
| cidr_block | The CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| public_subnet_cidrs | List of public subnet CIDR blocks | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]` | no |
| private_subnet_cidrs | List of private subnet CIDR blocks | `list(string)` | `["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]` | no |
| availability_zones | List of availability zones to use | `list(string)` | `["us-east-1a", "us-east-1b", "us-east-1c"]` | no |
| enable_nat_gateway | Whether to create NAT Gateway for outbound connectivity | `bool` | `true` | no |
| single_nat_gateway | Whether to provision a single shared NAT Gateway | `bool` | `true` | no |
| one_nat_gateway_per_az | Should be true if you want only one NAT Gateway per availability zone | `bool` | `false` | no |
| enable_flow_log | Whether or not to enable VPC Flow Logs | `bool` | `true` | no |
| enable_s3_endpoint | Should be true if you want to provision an S3 endpoint | `bool` | `true` | no |
| common_tags | Common tags to be applied to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_arn | The ARN of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| public_subnets | List of IDs of public subnets |
| private_subnets | List of IDs of private subnets |
| internet_gateway_id | The ID of the Internet Gateway |
| nat_gateway_ids | List of NAT Gateway IDs |
| nat_public_ips | List of public Elastic IPs created for AWS NAT Gateway |
| vpc_endpoint_s3_id | The ID of VPC endpoint for S3 |
| default_security_group_id | The ID of the security group created by default on VPC creation |
| vpc_flow_log_id | The ID of the Flow Log resource |
| dhcp_options_id | The ID of the DHCP options |
| azs | A list of availability zones specified as argument to this module |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws) | module |

## License

This module is licensed under the MIT License.
