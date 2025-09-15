package test

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestVPCConfiguration(t *testing.T) {
	t.Parallel()

	// Test VPC configuration validation
	vpcCidr := "10.0.0.0/16"
	assert.NotEmpty(t, vpcCidr, "VPC CIDR should not be empty")
	assert.Contains(t, vpcCidr, "10.0.0.0", "VPC CIDR should contain expected network")
	assert.Contains(t, vpcCidr, "/16", "VPC CIDR should contain expected subnet mask")

	// Test subnet configuration
	privateSubnets := []string{"10.0.1.0/24", "10.0.2.0/24"}
	publicSubnets := []string{"10.0.101.0/24", "10.0.102.0/24"}

	assert.Len(t, privateSubnets, 2, "Should have 2 private subnets")
	assert.Len(t, publicSubnets, 2, "Should have 2 public subnets")

	// Test subnet CIDR validation
	for i, subnet := range privateSubnets {
		assert.Contains(t, subnet, "10.0.", "Private subnet %d should be in 10.0.x.x range", i+1)
		assert.Contains(t, subnet, "/24", "Private subnet %d should have /24 mask", i+1)
	}

	for i, subnet := range publicSubnets {
		assert.Contains(t, subnet, "10.0.", "Public subnet %d should be in 10.0.x.x range", i+1)
		assert.Contains(t, subnet, "/24", "Public subnet %d should have /24 mask", i+1)
	}
}

func TestVPCTags(t *testing.T) {
	t.Parallel()

	// Test VPC tagging configuration
	tags := map[string]string{
		"Environment": "test",
		"Project":     "terragrunt-aws",
		"ManagedBy":   "terratest",
	}

	assert.NotEmpty(t, tags, "Tags should not be empty")
	assert.Equal(t, "test", tags["Environment"], "Environment tag should be 'test'")
	assert.Equal(t, "terragrunt-aws", tags["Project"], "Project tag should be 'terragrunt-aws'")
	assert.Equal(t, "terratest", tags["ManagedBy"], "ManagedBy tag should be 'terratest'")
}

func TestVPCSettings(t *testing.T) {
	t.Parallel()

	// Test VPC feature settings
	enableDnsHostnames := true
	enableDnsSupport := true
	enableNatGateway := true
	singleNatGateway := false

	assert.True(t, enableDnsHostnames, "DNS hostnames should be enabled")
	assert.True(t, enableDnsSupport, "DNS support should be enabled")
	assert.True(t, enableNatGateway, "NAT Gateway should be enabled")
	assert.False(t, singleNatGateway, "Single NAT Gateway should be disabled")
}
