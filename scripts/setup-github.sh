#!/bin/bash

# Setup GitHub Repository for Terragrunt AWS
# This script initializes a GitHub repository and configures it for CI/CD

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

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) is not installed. Please install it first:"
    print_error "https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    print_error "Not authenticated with GitHub. Please run: gh auth login"
    exit 1
fi

# Get repository name from current directory
REPO_NAME=$(basename "$(pwd)")
GITHUB_USERNAME=$(gh api user --jq .login)

print_status "Setting up GitHub repository: $GITHUB_USERNAME/$REPO_NAME"

# Initialize git repository if not already initialized
if [ ! -d ".git" ]; then
    print_status "Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit: Terragrunt AWS infrastructure"
fi

# Create GitHub repository
print_status "Creating GitHub repository..."
if gh repo view "$GITHUB_USERNAME/$REPO_NAME" &> /dev/null; then
    print_warning "Repository $GITHUB_USERNAME/$REPO_NAME already exists"
else
    gh repo create "$GITHUB_USERNAME/$REPO_NAME" --public --description "AWS Infrastructure as Code using Terraform and Terragrunt"
    print_status "Repository created successfully"
fi

# Add remote origin
print_status "Adding remote origin..."
git remote add origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git" 2>/dev/null || print_warning "Remote origin already exists"

# Create main branch
print_status "Creating main branch..."
git checkout -b main 2>/dev/null || git checkout main

# Push to GitHub
print_status "Pushing code to GitHub..."
git add .
git commit -m "Add CI/CD pipeline and infrastructure modules" || print_warning "No changes to commit"
git push -u origin main

# Create develop branch
print_status "Creating develop branch..."
git checkout -b develop
git push -u origin develop

# Switch back to main
git checkout main

# Set up branch protection rules
print_status "Setting up branch protection rules..."
gh api repos/$GITHUB_USERNAME/$REPO_NAME/branches/main/protection \
    --method PUT \
    --field required_status_checks='{"strict":true,"contexts":["Terraform Format Check","Terraform Validate","Security Scan"]}' \
    --field enforce_admins=true \
    --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
    --field restrictions=null

# Create environments
print_status "Creating GitHub environments..."
gh api repos/$GITHUB_USERNAME/$REPO_NAME/environments/dev --method PUT --field protection_rules='[{"type":"required_reviewers","reviewers":[{"type":"User","id":'$(gh api user --jq .id)'}]}]' 2>/dev/null || print_warning "Dev environment already exists"

gh api repos/$GITHUB_USERNAME/$REPO_NAME/environments/staging --method PUT --field protection_rules='[{"type":"required_reviewers","reviewers":[{"type":"User","id":'$(gh api user --jq .id)'}]}]' 2>/dev/null || print_warning "Staging environment already exists"

gh api repos/$GITHUB_USERNAME/$REPO_NAME/environments/prod --method PUT --field protection_rules='[{"type":"required_reviewers","reviewers":[{"type":"User","id":'$(gh api user --jq .id)'}]}]' 2>/dev/null || print_warning "Prod environment already exists"

# Get AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null || echo "YOUR_AWS_ACCOUNT_ID")

print_status "GitHub repository setup completed successfully!"
print_status "Repository URL: https://github.com/$GITHUB_USERNAME/$REPO_NAME"

print_warning "Next steps:"
print_warning "1. Configure GitHub repository secrets:"
print_warning "   - Go to: https://github.com/$GITHUB_USERNAME/$REPO_NAME/settings/secrets/actions"
print_warning "   - Add the following secrets:"
print_warning "     * AWS_ACCESS_KEY_ID: Your AWS access key"
print_warning "     * AWS_SECRET_ACCESS_KEY: Your AWS secret key"
print_warning "     * AWS_ACCOUNT_ID: $AWS_ACCOUNT_ID"
print_warning ""
print_warning "2. Update the IAM role trust policy with your repository name:"
print_warning "   - Repository: $GITHUB_USERNAME/$REPO_NAME"
print_warning ""
print_warning "3. Test the CI/CD pipeline by pushing changes to the develop branch"
