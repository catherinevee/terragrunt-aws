package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestVPCModule(t *testing.T) {
	t.Parallel()

	// AWS region to test in
	awsRegion := "us-east-1"

	// Temporarily rename versions.tf to avoid backend conflict
	versionsFile := "../modules/vpc/versions.tf"
	versionsBackup := "../modules/vpc/versions.tf.backup"

	// Backup the original versions.tf
	err := os.Rename(versionsFile, versionsBackup)
	if err != nil {
		t.Fatalf("Failed to backup versions.tf: %v", err)
	}
	defer os.Rename(versionsBackup, versionsFile)

	// Create a temporary backend configuration file
	backendConfig := `
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}
`

	// Write the backend config to a temporary file
	backendConfigFile := "../modules/vpc/versions.tf"
	err = os.WriteFile(backendConfigFile, []byte(backendConfig), 0644)
	if err != nil {
		t.Fatalf("Failed to create backend config file: %v", err)
	}

	// Terraform options for the VPC module
	terraformOptions := &terraform.Options{
		// Path to the VPC module
		TerraformDir: "../modules/vpc",
		// Force reconfiguration to use local backend
		Reconfigure: true,

		// Variables to pass to the module
		Vars: map[string]interface{}{
			"environment":          "test",
			"cidr_block":           "10.0.0.0/16",
			"availability_zones":   []string{"us-east-1a", "us-east-1b"},
			"private_subnet_cidrs": []string{"10.0.1.0/24", "10.0.2.0/24"},
			"public_subnet_cidrs":  []string{"10.0.101.0/24", "10.0.102.0/24"},
			"enable_nat_gateway":   true,
			"single_nat_gateway":   false,
			"enable_flow_log":      true,
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

	// Get the VPC ID
	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	assert.NotEmpty(t, vpcId, "VPC ID should not be empty")

	// Get the VPC CIDR block
	vpcCidr := terraform.Output(t, terraformOptions, "vpc_cidr_block")
	assert.Equal(t, "10.0.0.0/16", vpcCidr, "VPC CIDR should match expected value")

	// Get private subnet IDs
	privateSubnetIds := terraform.OutputList(t, terraformOptions, "private_subnets")
	assert.Len(t, privateSubnetIds, 2, "Should have 2 private subnets")

	// Get public subnet IDs
	publicSubnetIds := terraform.OutputList(t, terraformOptions, "public_subnets")
	assert.Len(t, publicSubnetIds, 2, "Should have 2 public subnets")

	// Verify subnet IDs are not empty
	for i, subnetId := range privateSubnetIds {
		assert.NotEmpty(t, subnetId, "Private subnet %d ID should not be empty", i+1)
	}

	for i, subnetId := range publicSubnetIds {
		assert.NotEmpty(t, subnetId, "Public subnet %d ID should not be empty", i+1)
	}

	// Verify NAT Gateway exists
	natGatewayIds := terraform.OutputList(t, terraformOptions, "nat_gateway_ids")
	assert.Len(t, natGatewayIds, 2, "Should have 2 NAT Gateways")

	// Verify Internet Gateway exists
	igwId := terraform.Output(t, terraformOptions, "internet_gateway_id")
	assert.NotEmpty(t, igwId, "Internet Gateway ID should not be empty")

	// Verify route tables exist
	privateRouteTableIds := terraform.OutputList(t, terraformOptions, "private_route_table_ids")
	assert.Len(t, privateRouteTableIds, 2, "Should have 2 private route tables")

	publicRouteTableIds := terraform.OutputList(t, terraformOptions, "public_route_table_ids")
	assert.Len(t, publicRouteTableIds, 1, "Should have 1 public route table")

	// Verify VPC Flow Logs are enabled
	flowLogId := terraform.Output(t, terraformOptions, "vpc_flow_log_id")
	assert.NotEmpty(t, flowLogId, "VPC Flow Log ID should not be empty")
}
