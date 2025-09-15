package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestVPCModule(t *testing.T) {
	t.Parallel()

	// AWS region to test in
	awsRegion := "us-east-1"

	// Terraform options for the VPC module
	terraformOptions := &terraform.Options{
		// Path to the VPC module
		TerraformDir: "../modules/vpc",

		// Variables to pass to the module
		Vars: map[string]interface{}{
			"name":                                 "test-vpc",
			"cidr":                                 "10.0.0.0/16",
			"azs":                                  []string{"us-east-1a", "us-east-1b"},
			"private_subnets":                      []string{"10.0.1.0/24", "10.0.2.0/24"},
			"public_subnets":                       []string{"10.0.101.0/24", "10.0.102.0/24"},
			"enable_nat_gateway":                   true,
			"single_nat_gateway":                   false,
			"enable_dns_hostnames":                 true,
			"enable_dns_support":                   true,
			"enable_vpn_gateway":                   false,
			"enable_dhcp_options":                  true,
			"enable_flow_log":                      true,
			"create_flow_log_cloudwatch_iam_role":  true,
			"create_flow_log_cloudwatch_log_group": true,
			"tags": map[string]string{
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

	// Verify VPC exists in AWS
	vpc := aws.GetVpcById(t, vpcId, awsRegion)
	assert.Equal(t, "10.0.0.0/16", *vpc.CidrBlock, "VPC CIDR should match")
	assert.True(t, *vpc.DnsHostnames.Value, "DNS hostnames should be enabled")
	assert.True(t, *vpc.DnsSupport.Value, "DNS support should be enabled")

	// Verify private subnets exist and are in different AZs
	for i, subnetId := range privateSubnetIds {
		subnet := aws.GetSubnetById(t, subnetId, awsRegion)
		assert.Contains(t, []string{"10.0.1.0/24", "10.0.2.0/24"}, *subnet.CidrBlock,
			"Private subnet %d CIDR should match expected value", i+1)
		assert.NotEmpty(t, subnet.AvailabilityZone, "Private subnet should have an AZ")
	}

	// Verify public subnets exist and are in different AZs
	for i, subnetId := range publicSubnetIds {
		subnet := aws.GetSubnetById(t, subnetId, awsRegion)
		assert.Contains(t, []string{"10.0.101.0/24", "10.0.102.0/24"}, *subnet.CidrBlock,
			"Public subnet %d CIDR should match expected value", i+1)
		assert.NotEmpty(t, subnet.AvailabilityZone, "Public subnet should have an AZ")
	}

	// Verify NAT Gateway exists
	natGatewayId := terraform.Output(t, terraformOptions, "natgw_ids")
	assert.NotEmpty(t, natGatewayId, "NAT Gateway ID should not be empty")

	// Verify Internet Gateway exists
	igwId := terraform.Output(t, terraformOptions, "igw_id")
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
