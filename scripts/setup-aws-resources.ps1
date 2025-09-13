# Setup AWS Resources for Terragrunt
# This script creates the necessary AWS resources for the Terragrunt state management

param(
    [string]$AWSRegion = "us-east-1"
)

# Function to print colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

try {
    # Get AWS account ID
    $AWSAccountId = (aws sts get-caller-identity --query Account --output text)
    $BucketName = "terragrunt-$AWSAccountId-state"
    $DynamoDBTable = "terraform-locks"

    Write-Status "Setting up AWS resources for Terragrunt"
    Write-Status "AWS Account ID: $AWSAccountId"
    Write-Status "AWS Region: $AWSRegion"
    Write-Status "S3 Bucket: $BucketName"
    Write-Status "DynamoDB Table: $DynamoDBTable"

    # Create S3 bucket for Terraform state
    Write-Status "Creating S3 bucket for Terraform state..."
    $bucketExists = aws s3api head-bucket --bucket $BucketName 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Warning "S3 bucket $BucketName already exists"
    } else {
        aws s3api create-bucket --bucket $BucketName --region $AWSRegion
        if ($LASTEXITCODE -eq 0) {
            Write-Status "S3 bucket $BucketName created successfully"
        } else {
            Write-Error "Failed to create S3 bucket"
            exit 1
        }
    }

    # Enable versioning on S3 bucket
    Write-Status "Enabling versioning on S3 bucket..."
    aws s3api put-bucket-versioning --bucket $BucketName --versioning-configuration Status=Enabled

    # Enable encryption on S3 bucket
    Write-Status "Enabling encryption on S3 bucket..."
    $encryptionConfig = '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'

    aws s3api put-bucket-encryption --bucket $BucketName --server-side-encryption-configuration $encryptionConfig

    # Block public access on S3 bucket
    Write-Status "Blocking public access on S3 bucket..."
    $publicAccessBlock = '{
        "BlockPublicAcls": true,
        "IgnorePublicAcls": true,
        "BlockPublicPolicy": true,
        "RestrictPublicBuckets": true
    }'

    aws s3api put-public-access-block --bucket $BucketName --public-access-block-configuration $publicAccessBlock

    # Create DynamoDB table for state locking
    Write-Status "Creating DynamoDB table for state locking..."
    $tableExists = aws dynamodb describe-table --table-name $DynamoDBTable 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Warning "DynamoDB table $DynamoDBTable already exists"
    } else {
        aws dynamodb create-table `
            --table-name $DynamoDBTable `
            --attribute-definitions AttributeName=LockID,AttributeType=S `
            --key-schema AttributeName=LockID,KeyType=HASH `
            --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 `
            --region $AWSRegion

        if ($LASTEXITCODE -eq 0) {
            Write-Status "Waiting for DynamoDB table to be active..."
            aws dynamodb wait table-exists --table-name $DynamoDBTable --region $AWSRegion
            Write-Status "DynamoDB table $DynamoDBTable created successfully"
        } else {
            Write-Error "Failed to create DynamoDB table"
            exit 1
        }
    }

    # Create IAM role for GitHub Actions
    Write-Status "Creating IAM role for GitHub Actions..."
    $RoleName = "GitHubActions-Terragrunt"
    $TrustPolicy = '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Federated": "arn:aws:iam::' + $AWSAccountId + ':oidc-provider/token.actions.githubusercontent.com"
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

    $roleExists = aws iam get-role --role-name $RoleName 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Warning "IAM role $RoleName already exists"
    } else {
        aws iam create-role --role-name $RoleName --assume-role-policy-document $TrustPolicy
        if ($LASTEXITCODE -eq 0) {
            Write-Status "IAM role $RoleName created successfully"
        } else {
            Write-Error "Failed to create IAM role"
            exit 1
        }
    }

    # Attach necessary policies to the role
    Write-Status "Attaching policies to IAM role..."
    aws iam attach-role-policy --role-name $RoleName --policy-arn "arn:aws:iam::aws:policy/PowerUserAccess"

    # Create OIDC provider for GitHub Actions
    Write-Status "Creating OIDC provider for GitHub Actions..."
    $oidcProviderArn = "arn:aws:iam::${AWSAccountId}:oidc-provider/token.actions.githubusercontent.com"
    $oidcExists = aws iam get-open-id-connect-provider --open-id-connect-provider-arn $oidcProviderArn 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Warning "OIDC provider already exists"
    } else {
        aws iam create-open-id-connect-provider `
            --url "https://token.actions.githubusercontent.com" `
            --client-id-list "sts.amazonaws.com" `
            --thumbprint-list "6938fd4d98bab03faadb97b34396831e3780aea1" `
            --tags Key=Name,Value=GitHubActions

        if ($LASTEXITCODE -eq 0) {
            Write-Status "OIDC provider created successfully"
        } else {
            Write-Error "Failed to create OIDC provider"
            exit 1
        }
    }

    Write-Status "AWS resources setup completed successfully!"
    Write-Status "S3 Bucket: $BucketName"
    Write-Status "DynamoDB Table: $DynamoDBTable"
    Write-Status "IAM Role: $RoleName"
    Write-Status "OIDC Provider: token.actions.githubusercontent.com"

    Write-Warning "Next steps:"
    Write-Warning "1. Update the repository name in the IAM role trust policy"
    Write-Warning "2. Configure GitHub repository secrets:"
    Write-Warning "   - AWS_ACCESS_KEY_ID"
    Write-Warning "   - AWS_SECRET_ACCESS_KEY"
    Write-Warning "   - AWS_ACCOUNT_ID"
    Write-Warning "3. Push your code to trigger the CI/CD pipeline"

} catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
    exit 1
}
