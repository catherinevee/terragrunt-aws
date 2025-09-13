# CI/CD Setup Guide for Terragrunt AWS

This guide explains how to set up and deploy the Terragrunt AWS infrastructure using GitHub Actions and AWS CLI.

## 🚀 Quick Start

### Prerequisites

1. **AWS CLI** - Configured with appropriate credentials
2. **GitHub CLI** - For repository management
3. **Terraform** >= 1.5.0
4. **Terragrunt** >= 0.50.0

### 1. Set Up AWS Resources

Run the setup script to create necessary AWS resources:

```bash
# For Linux/Mac
chmod +x scripts/setup-aws-resources.sh
./scripts/setup-aws-resources.sh

# For Windows PowerShell
.\scripts\setup-aws-resources.ps1
```

This script creates:
- S3 bucket for Terraform state storage
- DynamoDB table for state locking
- IAM role for GitHub Actions
- OIDC provider for GitHub Actions

### 2. Set Up GitHub Repository

```bash
# For Linux/Mac
chmod +x scripts/setup-github.sh
./scripts/setup-github.sh

# For Windows PowerShell
# Use GitHub CLI directly
gh repo create your-username/terragrunt-aws --public
```

### 3. Configure GitHub Secrets

Go to your repository settings and add these secrets:

- `AWS_ACCESS_KEY_ID` - Your AWS access key
- `AWS_SECRET_ACCESS_KEY` - Your AWS secret key
- `AWS_ACCOUNT_ID` - Your AWS account ID

### 4. Deploy Infrastructure

```bash
# For Linux/Mac
chmod +x scripts/deploy.sh
./scripts/deploy.sh -e dev -a plan
./scripts/deploy.sh -e dev -a apply

# For Windows PowerShell
.\scripts\deploy.ps1 -Environment dev -Action plan
.\scripts\deploy.ps1 -Environment dev -Action apply
```

## 📋 CI/CD Pipeline Overview

### Workflow Files

1. **`.github/workflows/terraform.yml`** - Main CI pipeline with validation and security checks
2. **`.github/workflows/deploy-dev.yml`** - Development environment deployment
3. **`.github/workflows/deploy-staging.yml`** - Staging environment deployment
4. **`.github/workflows/deploy-prod.yml`** - Production environment deployment

### Pipeline Stages

#### 1. Validation Stage
- **Terraform Format Check** - Ensures code formatting consistency
- **Terraform Validate** - Validates Terraform configuration
- **Security Scan** - Runs TFSec security analysis

#### 2. Planning Stage
- **Terraform Plan** - Creates execution plans for each environment
- **Artifact Storage** - Stores plans for review

#### 3. Deployment Stage
- **Environment-specific deployment** - Deploys to dev/staging/prod
- **Infrastructure verification** - Validates deployment success

## 🔧 Manual Deployment

### Using Terragrunt Directly

```bash
# Navigate to environment
cd environments/dev/us-east-1/vpc

# Initialize
terragrunt init

# Plan
terragrunt plan

# Apply
terragrunt apply
```

### Using Deployment Scripts

```bash
# Plan deployment
./scripts/deploy.sh -e dev -a plan

# Apply deployment
./scripts/deploy.sh -e dev -a apply

# Destroy deployment
./scripts/deploy.sh -e dev -a destroy
```

## 🏗️ Infrastructure Components

### Deployment Order

1. **VPC** - Network foundation
2. **KMS** - Encryption keys
3. **EKS** - Kubernetes cluster
4. **RDS** - Database (optional)
5. **S3** - Object storage (optional)
6. **Monitoring** - CloudWatch setup (optional)

### Environment-Specific Configurations

#### Development
- Single NAT Gateway (cost optimization)
- Smaller instance types
- Basic monitoring

#### Staging
- Multiple NAT Gateways
- Medium instance types
- Enhanced monitoring

#### Production
- Multiple NAT Gateways
- Large instance types
- Full monitoring and security

## 🔒 Security Considerations

### IAM Roles
- **GitHubActions-Terragrunt** - Role for CI/CD pipeline
- **Environment-specific roles** - For each deployment environment

### State Management
- **S3 encryption** - State files encrypted at rest
- **DynamoDB locking** - Prevents concurrent modifications
- **Versioning** - State file versioning enabled

### Network Security
- **VPC isolation** - Separate VPCs per environment
- **Security groups** - Restrictive firewall rules
- **Private subnets** - Database and compute resources

## 📊 Monitoring and Observability

### CloudWatch Integration
- **Log groups** - Centralized logging
- **Metrics** - Performance monitoring
- **Alarms** - Automated alerting

### EKS Monitoring
- **Cluster logging** - API server, audit, and application logs
- **Node monitoring** - Instance health and performance
- **Pod monitoring** - Application-level metrics

## 🚨 Troubleshooting

### Common Issues

#### 1. AWS Credentials
```bash
# Check AWS configuration
aws sts get-caller-identity

# Configure if needed
aws configure
```

#### 2. Terragrunt Issues
```bash
# Clean Terragrunt cache
terragrunt run-all clean

# Reinitialize
terragrunt init
```

#### 3. State Lock Issues
```bash
# Force unlock (use with caution)
terragrunt force-unlock LOCK_ID
```

#### 4. GitHub Actions Failures
- Check AWS credentials in repository secrets
- Verify IAM role permissions
- Review workflow logs for specific errors

### Debug Commands

```bash
# Check Terragrunt configuration
terragrunt run-all plan --terragrunt-log-level debug

# Validate Terraform configuration
terragrunt validate

# Check AWS resources
aws ec2 describe-vpcs
aws eks list-clusters
aws s3 ls
```

## 📚 Additional Resources

- [Terragrunt Documentation](https://terragrunt.gruntwork.io/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Test locally with `terragrunt plan`
4. Submit a pull request
5. Wait for CI/CD validation
6. Merge after approval

## 📞 Support

For issues and questions:
1. Check the troubleshooting section
2. Review GitHub Actions logs
3. Create an issue in the repository
4. Contact the platform team
