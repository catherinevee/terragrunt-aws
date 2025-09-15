#!/bin/bash

# Setup script for Terratest environment
# This script sets up the Go environment and installs dependencies for running Terratests

set -e

echo "=== Setting up Terratest Environment ==="

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Go is not installed. Please install Go 1.21 or later."
    echo "   Download from: https://golang.org/dl/"
    exit 1
fi

# Check Go version
GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
REQUIRED_VERSION="1.21"
if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$GO_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo "❌ Go version $GO_VERSION is too old. Please install Go $REQUIRED_VERSION or later."
    exit 1
fi

echo "✅ Go version $GO_VERSION is compatible"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI is not installed. Please install AWS CLI."
    echo "   Download from: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    exit 1
fi

echo "✅ AWS CLI is installed"

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install Terraform 1.6.0 or later."
    echo "   Download from: https://www.terraform.io/downloads.html"
    exit 1
fi

echo "✅ Terraform is installed"

# Check if Terragrunt is installed
if ! command -v terragrunt &> /dev/null; then
    echo "❌ Terragrunt is not installed. Please install Terragrunt 0.58.0 or later."
    echo "   Download from: https://terragrunt.gruntwork.io/docs/getting-started/install/"
    exit 1
fi

echo "✅ Terragrunt is installed"

# Navigate to test directory
cd test

# Initialize Go module
echo "📦 Initializing Go module..."
go mod init github.com/catherinevee/terragrunt-aws/test 2>/dev/null || echo "Go module already initialized"

# Download dependencies
echo "📥 Downloading dependencies..."
go mod download

# Tidy up dependencies
echo "🧹 Tidying up dependencies..."
go mod tidy

# Verify dependencies
echo "🔍 Verifying dependencies..."
go mod verify

echo ""
echo "✅ Terratest environment setup complete!"
echo ""
echo "You can now run tests with:"
echo "  cd test"
echo "  go test -v"
echo ""
echo "Or run specific tests:"
echo "  go test -v -run TestVPCModule"
echo "  go test -v -run TestS3Module"
echo "  go test -v -run TestSecurityGroupsModule"
echo ""
echo "Make sure your AWS credentials are configured:"
echo "  aws configure"
echo "  # or"
echo "  export AWS_ACCESS_KEY_ID=your_access_key"
echo "  export AWS_SECRET_ACCESS_KEY=your_secret_key"
echo "  export AWS_DEFAULT_REGION=us-east-1"
