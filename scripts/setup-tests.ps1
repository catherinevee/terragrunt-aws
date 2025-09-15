# Setup script for Terratest environment (PowerShell)
# This script sets up the Go environment and installs dependencies for running Terratests

Write-Host "=== Setting up Terratest Environment ===" -ForegroundColor Green

# Check if Go is installed
try {
    $goVersion = go version
    Write-Host "✅ Go is installed: $goVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Go is not installed. Please install Go 1.21 or later." -ForegroundColor Red
    Write-Host "   Download from: https://golang.org/dl/" -ForegroundColor Yellow
    exit 1
}

# Check if AWS CLI is installed
try {
    $awsVersion = aws --version
    Write-Host "✅ AWS CLI is installed: $awsVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ AWS CLI is not installed. Please install AWS CLI." -ForegroundColor Red
    Write-Host "   Download from: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html" -ForegroundColor Yellow
    exit 1
}

# Check if Terraform is installed
try {
    $terraformVersion = terraform version
    Write-Host "✅ Terraform is installed: $terraformVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Terraform is not installed. Please install Terraform 1.6.0 or later." -ForegroundColor Red
    Write-Host "   Download from: https://www.terraform.io/downloads.html" -ForegroundColor Yellow
    exit 1
}

# Check if Terragrunt is installed
try {
    $terragruntVersion = terragrunt version
    Write-Host "✅ Terragrunt is installed: $terragruntVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Terragrunt is not installed. Please install Terragrunt 0.58.0 or later." -ForegroundColor Red
    Write-Host "   Download from: https://terragrunt.gruntwork.io/docs/getting-started/install/" -ForegroundColor Yellow
    exit 1
}

# Navigate to test directory
Set-Location test

# Initialize Go module
Write-Host "📦 Initializing Go module..." -ForegroundColor Blue
try {
    go mod init github.com/catherinevee/terragrunt-aws/test
    Write-Host "✅ Go module initialized" -ForegroundColor Green
} catch {
    Write-Host "ℹ️  Go module already initialized" -ForegroundColor Yellow
}

# Download dependencies
Write-Host "📥 Downloading dependencies..." -ForegroundColor Blue
go mod download

# Tidy up dependencies
Write-Host "🧹 Tidying up dependencies..." -ForegroundColor Blue
go mod tidy

# Verify dependencies
Write-Host "🔍 Verifying dependencies..." -ForegroundColor Blue
go mod verify

Write-Host ""
Write-Host "✅ Terratest environment setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "You can now run tests with:" -ForegroundColor Cyan
Write-Host "  cd test" -ForegroundColor White
Write-Host "  go test -v" -ForegroundColor White
Write-Host ""
Write-Host "Or run specific tests:" -ForegroundColor Cyan
Write-Host "  go test -v -run TestVPCModule" -ForegroundColor White
Write-Host "  go test -v -run TestS3Module" -ForegroundColor White
Write-Host "  go test -v -run TestSecurityGroupsModule" -ForegroundColor White
Write-Host ""
Write-Host "Make sure your AWS credentials are configured:" -ForegroundColor Cyan
Write-Host "  aws configure" -ForegroundColor White
Write-Host "  # or" -ForegroundColor White
Write-Host "  `$env:AWS_ACCESS_KEY_ID='your_access_key'" -ForegroundColor White
Write-Host "  `$env:AWS_SECRET_ACCESS_KEY='your_secret_key'" -ForegroundColor White
Write-Host "  `$env:AWS_DEFAULT_REGION='us-east-1'" -ForegroundColor White
