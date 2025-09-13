#!/bin/bash

# Setup AWS Resources for Terragrunt
# This script creates the necessary AWS resources for the Terragrunt state management

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Get AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION="us-east-1"
BUCKET_NAME="terragrunt-${AWS_ACCOUNT_ID}-state"
DYNAMODB_TABLE="terraform-locks"

print_status "Setting up AWS resources for Terragrunt"
print_status "AWS Account ID: ${AWS_ACCOUNT_ID}"
print_status "AWS Region: ${AWS_REGION}"
print_status "S3 Bucket: ${BUCKET_NAME}"
print_status "DynamoDB Table: ${DYNAMODB_TABLE}"

# Create S3 bucket for Terraform state
print_status "Creating S3 bucket for Terraform state..."
if aws s3api head-bucket --bucket "${BUCKET_NAME}" 2>/dev/null; then
    print_warning "S3 bucket ${BUCKET_NAME} already exists"
else
    aws s3api create-bucket --bucket "${BUCKET_NAME}" --region "${AWS_REGION}"
    print_status "S3 bucket ${BUCKET_NAME} created successfully"
fi

# Enable versioning on S3 bucket
print_status "Enabling versioning on S3 bucket..."
aws s3api put-bucket-versioning --bucket "${BUCKET_NAME}" --versioning-configuration Status=Enabled

# Enable encryption on S3 bucket
print_status "Enabling encryption on S3 bucket..."
aws s3api put-bucket-encryption --bucket "${BUCKET_NAME}" --server-side-encryption-configuration '{
    "Rules": [
        {
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
            }
        }
    ]
}'

# Block public access on S3 bucket
print_status "Blocking public access on S3 bucket..."
aws s3api put-public-access-block --bucket "${BUCKET_NAME}" --public-access-block-configuration '{
    "BlockPublicAcls": true,
    "IgnorePublicAcls": true,
    "BlockPublicPolicy": true,
    "RestrictPublicBuckets": true
}'

# Create DynamoDB table for state locking
print_status "Creating DynamoDB table for state locking..."
if aws dynamodb describe-table --table-name "${DYNAMODB_TABLE}" 2>/dev/null; then
    print_warning "DynamoDB table ${DYNAMODB_TABLE} already exists"
else
    aws dynamodb create-table \
        --table-name "${DYNAMODB_TABLE}" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
        --region "${AWS_REGION}"
    
    print_status "Waiting for DynamoDB table to be active..."
    aws dynamodb wait table-exists --table-name "${DYNAMODB_TABLE}" --region "${AWS_REGION}"
    print_status "DynamoDB table ${DYNAMODB_TABLE} created successfully"
fi

# Create IAM role for GitHub Actions
print_status "Creating IAM role for GitHub Actions..."
ROLE_NAME="GitHubActions-Terragrunt"
TRUST_POLICY='{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::'${AWS_ACCOUNT_ID}':oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:your-username/terragrunt-aws:*"
                }
            }
        }
    ]
}'

if aws iam get-role --role-name "${ROLE_NAME}" 2>/dev/null; then
    print_warning "IAM role ${ROLE_NAME} already exists"
else
    aws iam create-role --role-name "${ROLE_NAME}" --assume-role-policy-document "${TRUST_POLICY}"
    print_status "IAM role ${ROLE_NAME} created successfully"
fi

# Attach necessary policies to the role
print_status "Attaching policies to IAM role..."
aws iam attach-role-policy --role-name "${ROLE_NAME}" --policy-arn "arn:aws:iam::aws:policy/PowerUserAccess"

# Create OIDC provider for GitHub Actions
print_status "Creating OIDC provider for GitHub Actions..."
if aws iam get-open-id-connect-provider --open-id-connect-provider-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com" 2>/dev/null; then
    print_warning "OIDC provider already exists"
else
    aws iam create-open-id-connect-provider \
        --url "https://token.actions.githubusercontent.com" \
        --client-id-list "sts.amazonaws.com" \
        --thumbprint-list "6938fd4d98bab03faadb97b34396831e3780aea1" \
        --tags Key=Name,Value=GitHubActions
    print_status "OIDC provider created successfully"
fi

print_status "AWS resources setup completed successfully!"
print_status "S3 Bucket: ${BUCKET_NAME}"
print_status "DynamoDB Table: ${DYNAMODB_TABLE}"
print_status "IAM Role: ${ROLE_NAME}"
print_status "OIDC Provider: token.actions.githubusercontent.com"

print_warning "Next steps:"
print_warning "1. Update the repository name in the IAM role trust policy"
print_warning "2. Configure GitHub repository secrets:"
print_warning "   - AWS_ACCESS_KEY_ID"
print_warning "   - AWS_SECRET_ACCESS_KEY"
print_warning "   - AWS_ACCOUNT_ID"
print_warning "3. Push your code to trigger the CI/CD pipeline"
