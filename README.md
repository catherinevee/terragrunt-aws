# Terragrunt AWS Infrastructure as Code

[![Terraform CI/CD Pipeline](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terraform.yml/badge.svg)](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terraform.yml)
[![Terraform Destroy Pipeline](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terraform-destroy.yml/badge.svg)](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terraform-destroy.yml)
[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)](https://terraform.io/)
[![Terragrunt](https://img.shields.io/badge/terragrunt-%235835CC.svg?style=flat&logo=terraform&logoColor=white)](https://terragrunt.gruntwork.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=flat&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains Infrastructure as Code (IaC) for deploying and managing AWS infrastructure using Terraform and Terragrunt. The project follows best practices for managing multi-environment, multi-region AWS deployments and uses official Terraform Registry modules.

## 📊 Architecture Diagrams

- **[Complete Infrastructure Diagram](infrastructure-diagram.md)** - Comprehensive multi-region architecture
- **[Simple Infrastructure Overview](simple-infrastructure-diagram.md)** - Core components and flow
- **[Network Topology](network-topology-diagram.md)** - VPC, subnets, and security architecture

All diagrams are created using [Mermaid](https://mermaid-js.github.io/), an open-source diagramming library that renders directly in GitHub.

## 🚀 Features

- **Multi-environment support** (dev, staging, prod)
- **Modular architecture** for reusable components using Terraform Registry modules
- **Secure by default** with proper IAM roles, security groups, and network isolation
- **State management** with S3 backend and DynamoDB locking
- **Standardized structure** following AWS Well-Architected Framework
- **Comprehensive monitoring** with CloudWatch, X-Ray, and custom dashboards
- **High availability** with multi-AZ deployments and auto-scaling
- **Cost optimization** with lifecycle policies and intelligent tiering

## 📁 Project Structure

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
└── README.md                      # This file
```

## 🛠 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.6.0
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) >= 0.58.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured with appropriate credentials
- AWS IAM permissions to create and manage resources

### 📋 Version Compatibility
- **Terraform 1.6.0** + **Terragrunt 0.58.0** ✅ **Fully Compatible**
- Both versions are tested and supported together
- CI/CD pipelines use these exact versions for consistency

## 🚀 Getting Started

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

3. **Initialize the backend**
   Before applying any configurations, you need to create the S3 bucket and DynamoDB table for state management:
   ```bash
   # Create S3 bucket for state storage
   aws s3api create-bucket \
     --bucket terragrunt-$(aws sts get-caller-identity --query Account --output text)-state \
     --region us-east-1
   
   # Enable versioning
   aws s3api put-bucket-versioning \
     --bucket terragrunt-$(aws sts get-caller-identity --query Account --output text)-state \
     --versioning-configuration Status=Enabled
   
   # Create DynamoDB table for state locking
   aws dynamodb create-table \
     --table-name terraform-locks \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
   ```

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

## 🧩 Modules

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

## 🔄 CI/CD Pipeline

This project includes automated CI/CD pipelines for infrastructure deployment and destruction:

### 🚀 Deployment Pipeline
The **Terraform CI/CD Pipeline** automatically:
- ✅ **Format Check**: Validates Terraform code formatting
- ✅ **Validation**: Validates Terraform configurations across all environments
- ✅ **Planning**: Creates execution plans for all environments
- ✅ **Deployment**: Deploys infrastructure across multiple regions
- 🌍 **Multi-Region**: Deploys to dev (us-east-1), staging (us-west-2), prod (eu-west-1)

### 🔥 Destroy Pipeline
The **Terraform Destroy Pipeline** provides safe infrastructure destruction:
- 🛡️ **Safety Confirmation**: Requires typing "DESTROY" to proceed
- ✅ **Validation**: Validates infrastructure before destruction
- 🔥 **Destruction**: Safely destroys all infrastructure
- 🧹 **Cleanup**: Removes S3 buckets and DynamoDB tables

### 📊 Pipeline Status
- **Deployment Pipeline**: [![Terraform CI/CD Pipeline](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terraform.yml/badge.svg)](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terraform.yml)
- **Destroy Pipeline**: [![Terraform Destroy Pipeline](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terraform-destroy.yml/badge.svg)](https://github.com/catherinevee/terragrunt-aws/actions/workflows/terraform-destroy.yml)

### 🎮 Using the Pipelines

#### Deploy Infrastructure
The deployment pipeline runs automatically on every push to the main branch:
```bash
# Push changes to trigger deployment
git push origin main
```

#### Destroy Infrastructure
The destroy pipeline requires manual triggering for safety:
```bash
# Trigger destroy pipeline via GitHub CLI
gh workflow run "Terraform Destroy Pipeline" \
  --field environment="all" \
  --field region="all" \
  --field confirm_destroy="DESTROY"

# Or trigger via GitHub Web UI:
# 1. Go to Actions tab
# 2. Select "Terraform Destroy Pipeline"
# 3. Click "Run workflow"
# 4. Fill in the required fields
# 5. Click "Run workflow"
```

#### Monitor Pipeline Status
```bash
# Check deployment pipeline status
gh run list --workflow="terraform.yml" --limit 5

# Check destroy pipeline status
gh run list --workflow="terraform-destroy.yml" --limit 5

# View pipeline logs
gh run view --log
```

## 🔄 Development Workflow

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

## 🔒 Security

- All resources are tagged with environment and owner information
- IAM policies follow the principle of least privilege
- Sensitive data is stored in AWS Secrets Manager or Parameter Store
- Network traffic is encrypted in transit and at rest

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📧 Contact

For questions or support, please contact [Your Name] at [your.email@example.com].