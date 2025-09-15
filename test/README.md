# Terratest for Terragrunt AWS

This directory contains Terratest tests for the Terragrunt AWS infrastructure modules. Terratest is a Go library that makes it easier to write automated tests for your infrastructure code.

## Test Structure

- `vpc_test.go` - Tests for the VPC module
- `s3_test.go` - Tests for the S3 module  
- `security_groups_test.go` - Tests for the Security Groups module
- `go.mod` - Go module dependencies

## Prerequisites

- Go 1.21 or later
- AWS CLI configured with appropriate credentials
- Terraform and Terragrunt installed

## Running Tests

### Run All Tests
```bash
cd test
go test -v
```

### Run Specific Test
```bash
cd test
go test -v -run TestVPCModule
go test -v -run TestS3Module
go test -v -run TestSecurityGroupsModule
```

### Run Tests in Parallel
```bash
cd test
go test -v -parallel 4
```

## Test Configuration

Tests are configured to run in the `us-east-1` region by default. To change the region, modify the `awsRegion` variable in each test file.

## Test Coverage

The tests cover:

### VPC Module
- VPC creation with correct CIDR block
- Private and public subnet creation
- NAT Gateway configuration
- Internet Gateway setup
- Route table configuration
- VPC Flow Logs enablement
- DNS hostnames and support

### S3 Module
- S3 bucket creation
- Versioning configuration
- Server-side encryption
- Public access blocking
- Lifecycle rules

### Security Groups Module
- Security group creation
- Ingress rule configuration
- Egress rule configuration
- Rule descriptions and protocols

## CI/CD Integration

These tests are automatically run as part of the GitHub Actions workflow. The workflow:

1. Sets up Go environment
2. Installs dependencies
3. Configures AWS credentials
4. Runs all Terratest tests
5. Reports results and generates status badges

## Adding New Tests

To add tests for new modules:

1. Create a new test file following the naming convention `{module_name}_test.go`
2. Import the necessary Terratest modules
3. Define test functions with the `Test` prefix
4. Use `t.Parallel()` for parallel test execution
5. Follow the pattern of other test files for consistency

## Best Practices

- Use `t.Parallel()` to run tests in parallel when possible
- Always defer `terraform.Destroy()` to clean up resources
- Use descriptive test names and assertions
- Test both positive and negative scenarios
- Verify resources exist in AWS, not just in Terraform outputs
- Use appropriate timeouts for long-running operations
