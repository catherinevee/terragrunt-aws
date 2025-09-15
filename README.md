# Terragrunt AWS Infrastructure as Code

[![Terraform CI/CD Pipeline](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terraform.yml/badge.svg)](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terraform.yml)
[![Terratest CI/CD Pipeline](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terratest.yml/badge.svg)](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terratest.yml)
[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)](https://terraform.io/)
[![Terragrunt](https://img.shields.io/badge/terragrunt-%235835CC.svg?style=flat&logo=terraform&logoColor=white)](https://terragrunt.gruntwork.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=flat&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains Infrastructure as Code (IaC) for deploying and managing AWS infrastructure using Terraform and Terragrunt. The project follows best practices for managing multi-environment, multi-region AWS deployments and uses official Terraform Registry modules.

## Architecture Diagrams

- **[Complete Infrastructure Diagram](infrastructure-diagram.md)** - Comprehensive multi-region architecture
- **[Simple Infrastructure Overview](simple-infrastructure-diagram.md)** - Core components and flow
- **[Network Topology](network-topology-diagram.md)** - VPC, subnets, and security architecture

All diagrams are created using [Mermaid](https://mermaid-js.github.io/), an open-source diagramming library that renders directly in GitHub.

## Features

- **Multi-environment support** (dev, staging, prod)
- **Modular architecture** for reusable components using Terraform Registry modules
- **Secure by default** with proper IAM roles, security groups, and network isolation
- **State management** with S3 backend and DynamoDB locking
- **Standardized structure** following AWS Well-Architected Framework
- **Comprehensive monitoring** with CloudWatch, X-Ray, and custom dashboards
- **High availability** with multi-AZ deployments and auto-scaling
- **Cost optimization** with lifecycle policies and intelligent tiering

## Project Structure

```
.
├── environments/                    # Environment-specific configurations
│   ├── dev/                        # Development environment
│   │   └── us-east-1/             # Region-specific configurations
│   │       ├── vpc/               # VPC component
│   │       ├── eks/               # EKS cluster
│   │       └── kms/               # KMS keys
│   ├── staging/                    # Staging environment
│   │   └── us-west-2/             # Region-specific configurations
│   │       └── vpc/               # VPC component
│   └── prod/                       # Production environment
│       └── eu-west-1/             # Region-specific configurations
│           └── vpc/               # VPC component
├── modules/                        # Reusable Terraform modules
│   ├── networking/                # Networking modules
│   │   ├── security-groups/       # Security Groups module
│   │   ├── alb/                   # Application Load Balancer module
│   │   ├── nlb/                   # Network Load Balancer module
│   │   └── cloudfront/            # CloudFront module
│   ├── compute/                   # Compute modules
│   │   └── eks/                   # EKS cluster module
│   ├── data/                      # Data storage modules
│   │   ├── rds-aurora/            # RDS Aurora module
│   │   └── s3/                    # S3 bucket module
│   ├── security/                  # Security modules
│   │   ├── iam/                   # IAM module
│   │   └── kms/                   # KMS module
│   ├── monitoring/                # Monitoring modules
│   │   └── cloudwatch/            # CloudWatch module
│   └── vpc/                       # VPC module
│       ├── main.tf                # Main VPC resources
│       ├── variables.tf           # Input variables
│       ├── outputs.tf             # Output values
│       ├── versions.tf            # Version constraints
│       └── README.md              # Module documentation
├── terragrunt.hcl                 # Root Terragrunt configuration
├── test/                          # Terratest test files
│   ├── vpc_test.go               # VPC module tests
│   ├── s3_test.go                # S3 module tests
│   ├── security_groups_test.go   # Security Groups module tests
│   ├── go.mod                    # Go module dependencies
│   └── README.md                 # Test documentation
└── README.md                      # This file
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.6.0
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) >= 0.58.0
- [Go](https://golang.org/dl/) >= 1.21 (for running Terratests)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured with appropriate credentials
- AWS IAM permissions to create and manage resources

### Version Compatibility
- **Terraform 1.6.0** + **Terragrunt 0.58.0** - **Fully Compatible**
- Both versions are tested and supported together
- CI/CD pipelines use these exact versions for consistency

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/terragrunt-aws.git
   cd terragrunt-aws
   ```

2. **Set up AWS credentials**
   Configure your AWS credentials using one of these methods:
   - AWS CLI: `aws configure`
   - Environment variables: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
   - AWS credentials file: `~/.aws/credentials`

3. **Backend Configuration**
   The backend configuration is managed by individual environment terragrunt.hcl files:
   - Each environment uses region-specific S3 buckets with unique names
   - DynamoDB tables are region-specific for state locking
   - Backend configuration is automatically handled by Terragrunt
   - No manual S3 bucket or DynamoDB table creation required

4. **Deploy the infrastructure**
   ```bash
   # Navigate to the environment and component
   cd environments/dev/us-east-1/vpc
   
   # Initialize Terragrunt
   terragrunt init
   
   # Plan the deployment
   terragrunt plan
   
   # Apply the configuration
   terragrunt apply
   ```

## Modules

All modules use official Terraform Registry modules as their foundation and are designed to be production-ready with comprehensive security, monitoring, and cost optimization features.

### Networking Modules

#### VPC Module
Creates a complete VPC with public and private subnets, NAT Gateway, and route tables using `terraform-aws-modules/vpc/aws`.

**Features:**
- Configurable CIDR blocks for VPC and subnets
- Public and private subnets across multiple AZs
- Internet Gateway for public subnets
- NAT Gateway for private subnets
- VPC Flow Logs and endpoints
- Route tables and associations

#### Security Groups Module
Manages security groups using `terraform-aws-modules/security-group/aws`.

**Features:**
- Ingress and egress rules with CIDR blocks
- Source security group references
- Computed rules for dynamic configurations
- Additional security groups support

#### Load Balancer Modules
- **ALB Module**: Application Load Balancer using `terraform-aws-modules/alb/aws`
- **NLB Module**: Network Load Balancer using `terraform-aws-modules/alb/aws`

**Features:**
- Target groups with health checks
- SSL/TLS termination
- Access logging
- Cross-zone load balancing

#### CloudFront Module
Content delivery network using `terraform-aws-modules/cloudfront/aws`.

**Features:**
- Multiple origins support
- Cache behaviors and policies
- SSL certificates
- Geographic restrictions

### Compute Modules

#### EKS Module
Amazon EKS cluster using `terraform-aws-modules/eks/aws`.

**Features:**
- Managed node groups with auto-scaling
- Fargate profiles for serverless workloads
- Cluster add-ons (CoreDNS, kube-proxy, VPC CNI, EBS CSI)
- IAM Roles for Service Accounts (IRSA)
- KMS encryption for secrets
- CloudWatch logging

### Data Modules

#### RDS Aurora Module
Aurora PostgreSQL/MySQL clusters using `terraform-aws-modules/rds-aurora/aws`.

**Features:**
- Multi-AZ deployments
- Read replicas
- Automated backups
- Performance Insights
- Encryption at rest and in transit

#### S3 Module
S3 buckets using `terraform-aws-modules/s3-bucket/aws`.

**Features:**
- Server-side encryption
- Versioning and lifecycle policies
- Public access blocking
- Intelligent tiering
- Cross-region replication

### Security Modules

#### IAM Module
Identity and Access Management using `terraform-aws-modules/iam/aws`.

**Features:**
- Users, groups, and roles
- Policy attachments
- Instance profiles
- OIDC and SAML providers
- Service-linked roles

#### KMS Module
Key Management Service using `terraform-aws-modules/kms/aws`.

**Features:**
- Customer managed keys
- Key rotation
- Aliases and grants
- Multi-region keys
- External keys

### Monitoring Modules

#### CloudWatch Module
Monitoring and logging using `terraform-aws-modules/cloudwatch/aws`.

**Features:**
- Log groups and streams
- Metric filters and alarms
- Dashboards
- Anomaly detection
- Synthetics canaries

## CI/CD Pipeline

This project includes **two comprehensive CI/CD pipelines** for infrastructure deployment, testing, and destruction:

### 1. Terraform CI/CD Pipeline

The **Terraform CI/CD Pipeline** provides:
- **Format Check**: Validates Terraform code formatting
- **Validation**: Validates Terraform configurations across all environments
- **Planning**: Creates execution plans for all environments
- **Deployment**: Deploys infrastructure across multiple regions
- **Destruction**: Safely destroys infrastructure with confirmation
- **Multi-Region**: Supports dev (us-east-1), staging (us-west-2), prod (eu-west-1)

### 2. Terratest CI/CD Pipeline

The **Terratest CI/CD Pipeline** provides comprehensive testing for all infrastructure modules:

#### Test Types
- **Unit Tests**: Fast tests that don't require AWS resources
- **Integration Tests**: Full tests with real AWS resources
- **Security Tests**: Security scanning with gosec
- **Performance Tests**: Benchmark testing for module performance
- **Lint Tests**: Code quality and formatting checks

#### Test Coverage
- **VPC Module**: Tests VPC creation, subnets, NAT Gateway, Internet Gateway, route tables, and VPC Flow Logs
- **S3 Module**: Tests bucket creation, versioning, encryption, public access blocking, and lifecycle rules
- **Security Groups Module**: Tests security group creation, ingress/egress rules, and rule descriptions
- **Extensible**: Easy to add tests for new modules

#### Pipeline Features
- **Parallel Execution**: Tests run in parallel for faster execution
- **Resource Cleanup**: Automatic cleanup of test resources
- **Multi-Region Support**: Tests across us-east-1, us-west-2, eu-west-1
- **Comprehensive Reporting**: Detailed test reports and coverage metrics
- **Manual Triggers**: Support for running specific test types
- **Caching**: Go module caching for faster builds

#### Using the Terratest Pipeline

**Automatic Testing:**
```bash
# Tests run automatically on every push and pull request
git push origin main
```

**Manual Testing:**
```bash
# Run all tests
gh workflow run terratest.yml --ref main -f test_type=all

# Run specific test type
gh workflow run terratest.yml --ref main -f test_type=vpc -f environment=test -f region=us-east-1

# Run performance tests
gh workflow run terratest.yml --ref main -f test_type=all
```

**Local Testing:**
```bash
# Run tests locally
cd test
go test -v

# Run specific test
go test -v -run TestVPCModule

# Run with coverage
go test -v -coverprofile=coverage.out ./...
```

### Pipeline Status
- **Terraform CI/CD Pipeline**: [![Terraform CI/CD Pipeline](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terraform.yml/badge.svg)](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terraform.yml)
- **Terratest CI/CD Pipeline**: [![Terratest CI/CD Pipeline](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terratest.yml/badge.svg)](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terratest.yml)

### Using the Pipeline

#### Deploy Infrastructure
The deployment pipeline runs automatically on every push to the main branch, or can be triggered manually:

**Automatic Deployment:**
```bash
# Push changes to trigger deployment
git push origin main
```

**Manual Deployment:**
```bash
# Deploy to specific environment and region
gh workflow run terraform.yml --ref main -f action=deploy -f environment=dev -f region=us-east-1

# Deploy to all environments
gh workflow run terraform.yml --ref main -f action=deploy -f environment=all -f region=all
```

#### Destroy Infrastructure
The destroy pipeline requires manual triggering for safety:
```bash
# Destroy specific environment
gh workflow run terraform.yml --ref main -f action=destroy -f environment=dev -f region=us-east-1 -f confirm_destroy=DESTROY

# Destroy all infrastructure
gh workflow run terraform.yml --ref main -f action=destroy -f environment=all -f region=all -f confirm_destroy=DESTROY
```

#### Validate Only
Run validation across environments without deploying:
```bash
# Run validation across all environments
gh workflow run terraform.yml --ref main -f action=validate-only -f environment=all -f region=all
```

#### Monitor Pipeline Status
```bash
# Check pipeline status
gh run list --workflow="terraform.yml" --limit 5

# View specific run logs
gh run view <run-id> --log

# View latest run logs
gh run view --log
```

## Development Workflow

1. **Development**
   - Create feature branches for changes
   - Make changes to the infrastructure code
   - Test locally using `terragrunt plan`

2. **Code Review**
   - Open a pull request
   - Get approval from team members
   - Run automated tests and validations

3. **Deployment**
   - Merge changes to the main branch
   - CI/CD pipeline automatically deploys infrastructure
   - Verify the deployment using AWS console or CLI

## Security

- All resources are tagged with environment and owner information
- IAM policies follow the principle of least privilege
- Sensitive data is stored in AWS Secrets Manager or Parameter Store
- Network traffic is encrypted in transit and at rest

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Contact

For questions or support, please contact [Your Name] at [your.email@example.com].