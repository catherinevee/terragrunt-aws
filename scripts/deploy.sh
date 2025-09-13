#!/bin/bash

# Deploy Terragrunt AWS Infrastructure
# This script deploys the infrastructure to the specified environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Default values
ENVIRONMENT="dev"
REGION="us-east-1"
ACTION="plan"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -r|--region)
            REGION="$2"
            shift 2
            ;;
        -a|--action)
            ACTION="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -e, --environment ENV    Environment to deploy (dev, staging, prod)"
            echo "  -r, --region REGION      AWS region (default: us-east-1)"
            echo "  -a, --action ACTION      Action to perform (plan, apply, destroy)"
            echo "  -h, --help              Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option $1"
            exit 1
            ;;
    esac
done

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|prod)$ ]]; then
    print_error "Invalid environment: $ENVIRONMENT. Must be dev, staging, or prod"
    exit 1
fi

# Validate action
if [[ ! "$ACTION" =~ ^(plan|apply|destroy)$ ]]; then
    print_error "Invalid action: $ACTION. Must be plan, apply, or destroy"
    exit 1
fi

print_header "Terragrunt AWS Deployment"
print_status "Environment: $ENVIRONMENT"
print_status "Region: $REGION"
print_status "Action: $ACTION"

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    print_error "AWS CLI is not configured. Please run 'aws configure' first"
    exit 1
fi

# Check if Terragrunt is installed
if ! command -v terragrunt &> /dev/null; then
    print_error "Terragrunt is not installed. Please install it first:"
    print_error "https://terragrunt.gruntwork.io/docs/getting-started/install/"
    exit 1
fi

# Get AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
print_status "AWS Account ID: $AWS_ACCOUNT_ID"

# Set environment variables
export AWS_ACCOUNT_ID
export ENVIRONMENT
export AWS_REGION=$REGION

# Function to deploy a component
deploy_component() {
    local component=$1
    local component_path="environments/$ENVIRONMENT/$REGION/$component"
    
    if [ ! -d "$component_path" ]; then
        print_warning "Component $component not found in $component_path, skipping..."
        return
    fi
    
    print_status "Deploying $component..."
    cd "$component_path"
    
    # Initialize Terragrunt
    terragrunt init --terragrunt-non-interactive
    
    # Execute the action
    case $ACTION in
        plan)
            terragrunt plan
            ;;
        apply)
            terragrunt apply -auto-approve
            ;;
        destroy)
            print_warning "Destroying $component..."
            terragrunt destroy -auto-approve
            ;;
    esac
    
    cd - > /dev/null
}

# Deploy components in order
print_header "Deploying Infrastructure Components"

# 1. VPC (foundation)
deploy_component "vpc"

# 2. KMS (for encryption)
deploy_component "kms"

# 3. EKS (compute)
deploy_component "eks"

# 4. Additional components can be added here
# deploy_component "rds"
# deploy_component "s3"
# deploy_component "monitoring"

print_header "Deployment Summary"
print_status "Environment: $ENVIRONMENT"
print_status "Region: $REGION"
print_status "Action: $ACTION"
print_status "AWS Account: $AWS_ACCOUNT_ID"

if [ "$ACTION" = "apply" ]; then
    print_status "Infrastructure deployed successfully!"
    print_warning "Next steps:"
    print_warning "1. Verify the deployment in the AWS console"
    print_warning "2. Test the EKS cluster: aws eks update-kubeconfig --region $REGION --name $ENVIRONMENT-cluster"
    print_warning "3. Check the resources: kubectl get nodes"
elif [ "$ACTION" = "plan" ]; then
    print_status "Plan completed successfully!"
    print_warning "To apply the changes, run: $0 -e $ENVIRONMENT -a apply"
elif [ "$ACTION" = "destroy" ]; then
    print_warning "Infrastructure destroyed!"
    print_warning "Please verify that all resources have been removed from the AWS console"
fi
