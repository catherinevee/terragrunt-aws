package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestSecurityGroupsModule(t *testing.T) {
	t.Parallel()

	// AWS region to test in
	awsRegion := "us-east-1"

	// First create a VPC for the security group to attach to
	vpcTerraformOptions := &terraform.Options{
		TerraformDir: "../modules/vpc",
		// Use local backend for testing
		BackendConfig: map[string]interface{}{
			"backend": "local",
		},
		Vars: map[string]interface{}{
			"environment":            "test",
			"cidr_block":            "10.10.0.0/16",
			"availability_zones":    []string{"us-east-1a"},
			"private_subnet_cidrs":  []string{"10.10.1.0/24"},
			"public_subnet_cidrs":   []string{"10.10.101.0/24"},
			"enable_nat_gateway":    false,
			"common_tags": map[string]string{
				"Environment": "test",
				"Project":     "terragrunt-aws",
				"ManagedBy":   "terratest",
			},
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	defer terraform.Destroy(t, vpcTerraformOptions)
	terraform.InitAndApply(t, vpcTerraformOptions)
	vpcId := terraform.Output(t, vpcTerraformOptions, "vpc_id")

	// Terraform options for the Security Groups module
	terraformOptions := &terraform.Options{
		// Path to the Security Groups module
		TerraformDir: "../modules/networking/security-groups",
		// Use local backend for testing
		BackendConfig: map[string]interface{}{
			"backend": "local",
		},

		// Variables to pass to the module
		Vars: map[string]interface{}{
			"environment": "test",
			"name":        "test-security-group",
			"description": "Test security group for Terratest",
			"vpc_id":      vpcId,
			"ingress_with_cidr_blocks": []map[string]interface{}{
				{
					"from_port":   80,
					"to_port":     80,
					"protocol":    "tcp",
					"description": "HTTP",
					"cidr_blocks": []string{"0.0.0.0/0"},
				},
				{
					"from_port":   443,
					"to_port":     443,
					"protocol":    "tcp",
					"description": "HTTPS",
					"cidr_blocks": []string{"0.0.0.0/0"},
				},
			},
			"egress_with_cidr_blocks": []map[string]interface{}{
				{
					"from_port":   0,
					"to_port":     0,
					"protocol":    "-1",
					"description": "All outbound traffic",
					"cidr_blocks": []string{"0.0.0.0/0"},
				},
			},
			"common_tags": map[string]string{
				"Environment": "test",
				"Project":     "terragrunt-aws",
				"ManagedBy":   "terratest",
			},
		},

		// Environment variables
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	// Defer the destroy to clean up resources
	defer terraform.Destroy(t, terraformOptions)

	// Deploy the infrastructure
	terraform.InitAndApply(t, terraformOptions)

	// Get the security group ID
	securityGroupId := terraform.Output(t, terraformOptions, "security_group_id")
	assert.NotEmpty(t, securityGroupId, "Security group ID should not be empty")

	// Get the security group ARN
	securityGroupArn := terraform.Output(t, terraformOptions, "security_group_arn")
	assert.NotEmpty(t, securityGroupArn, "Security group ARN should not be empty")

	// Verify security group ID is not empty
	assert.NotEmpty(t, securityGroupId, "Security group ID should not be empty")
	assert.NotEmpty(t, securityGroupArn, "Security group ARN should not be empty")

	// Verify the security group ID follows the expected format
	assert.Contains(t, securityGroupId, "sg-", "Security group ID should start with 'sg-'")
}
