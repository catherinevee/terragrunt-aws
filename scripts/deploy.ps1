# Deploy Terragrunt AWS Infrastructure
# This script deploys the infrastructure to the specified environment

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("dev", "staging", "prod")]
    [string]$Environment = "dev",
    
    [Parameter(Mandatory=$false)]
    [string]$Region = "us-east-1",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("plan", "apply", "destroy")]
    [string]$Action = "plan"
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

function Write-Header {
    param([string]$Message)
    Write-Host "================================" -ForegroundColor Blue
    Write-Host $Message -ForegroundColor Blue
    Write-Host "================================" -ForegroundColor Blue
}

Write-Header "Terragrunt AWS Deployment"
Write-Status "Environment: $Environment"
Write-Status "Region: $Region"
Write-Status "Action: $Action"

# Check if AWS CLI is configured
try {
    $awsIdentity = aws sts get-caller-identity 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "AWS CLI not configured"
    }
} catch {
    Write-Error "AWS CLI is not configured. Please run 'aws configure' first"
    exit 1
}

# Check if Terragrunt is installed
try {
    $terragruntVersion = terragrunt --version 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Terragrunt not installed"
    }
} catch {
    Write-Error "Terragrunt is not installed. Please install it first:"
    Write-Error "https://terragrunt.gruntwork.io/docs/getting-started/install/"
    exit 1
}

# Get AWS account ID
$AWSAccountId = (aws sts get-caller-identity --query Account --output text)
Write-Status "AWS Account ID: $AWSAccountId"

# Set environment variables
$env:AWS_ACCOUNT_ID = $AWSAccountId
$env:ENVIRONMENT = $Environment
$env:AWS_REGION = $Region

# Function to deploy a component
function Deploy-Component {
    param(
        [string]$Component
    )
    
    $ComponentPath = "environments/$Environment/$Region/$Component"
    
    if (-not (Test-Path $ComponentPath)) {
        Write-Warning "Component $Component not found in $ComponentPath, skipping..."
        return
    }
    
    Write-Status "Deploying $Component..."
    Push-Location $ComponentPath
    
    try {
        # Initialize Terragrunt
        terragrunt init --terragrunt-non-interactive
        
        # Execute the action
        switch ($Action) {
            "plan" {
                terragrunt plan
            }
            "apply" {
                terragrunt apply -auto-approve
            }
            "destroy" {
                Write-Warning "Destroying $Component..."
                terragrunt destroy -auto-approve
            }
        }
    } finally {
        Pop-Location
    }
}

# Deploy components in order
Write-Header "Deploying Infrastructure Components"

# 1. VPC (foundation)
Deploy-Component "vpc"

# 2. KMS (for encryption)
Deploy-Component "kms"

# 3. EKS (compute)
Deploy-Component "eks"

# 4. Additional components can be added here
# Deploy-Component "rds"
# Deploy-Component "s3"
# Deploy-Component "monitoring"

Write-Header "Deployment Summary"
Write-Status "Environment: $Environment"
Write-Status "Region: $Region"
Write-Status "Action: $Action"
Write-Status "AWS Account: $AWSAccountId"

if ($Action -eq "apply") {
    Write-Status "Infrastructure deployed successfully!"
    Write-Warning "Next steps:"
    Write-Warning "1. Verify the deployment in the AWS console"
    Write-Warning "2. Test the EKS cluster: aws eks update-kubeconfig --region $Region --name $Environment-cluster"
    Write-Warning "3. Check the resources: kubectl get nodes"
} elseif ($Action -eq "plan") {
    Write-Status "Plan completed successfully!"
    Write-Warning "To apply the changes, run: .\deploy.ps1 -Environment $Environment -Action apply"
} elseif ($Action -eq "destroy") {
    Write-Warning "Infrastructure destroyed!"
    Write-Warning "Please verify that all resources have been removed from the AWS console"
}
