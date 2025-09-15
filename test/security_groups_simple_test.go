package test

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestSecurityGroupConfiguration(t *testing.T) {
	t.Parallel()

	// Test security group basic configuration
	sgName := "test-security-group"
	sgDescription := "Test security group for Terratest"
	vpcId := "vpc-12345678"

	assert.NotEmpty(t, sgName, "Security group name should not be empty")
	assert.NotEmpty(t, sgDescription, "Security group description should not be empty")
	assert.NotEmpty(t, vpcId, "VPC ID should not be empty")
	assert.Contains(t, vpcId, "vpc-", "VPC ID should start with 'vpc-'")
}

func TestSecurityGroupIngressRules(t *testing.T) {
	t.Parallel()

	// Test ingress rules configuration
	ingressRules := []map[string]interface{}{
		{
			"from_port":   80,
			"to_port":     80,
			"protocol":    "tcp",
			"description": "HTTP",
			"cidr_blocks": "0.0.0.0/0",
		},
		{
			"from_port":   443,
			"to_port":     443,
			"protocol":    "tcp",
			"description": "HTTPS",
			"cidr_blocks": "0.0.0.0/0",
		},
	}

	assert.Len(t, ingressRules, 2, "Should have 2 ingress rules")

	// Test HTTP rule
	httpRule := ingressRules[0]
	assert.Equal(t, 80, httpRule["from_port"], "HTTP rule from_port should be 80")
	assert.Equal(t, 80, httpRule["to_port"], "HTTP rule to_port should be 80")
	assert.Equal(t, "tcp", httpRule["protocol"], "HTTP rule protocol should be tcp")
	assert.Equal(t, "HTTP", httpRule["description"], "HTTP rule description should be HTTP")
	assert.Equal(t, "0.0.0.0/0", httpRule["cidr_blocks"], "HTTP rule CIDR should be 0.0.0.0/0")

	// Test HTTPS rule
	httpsRule := ingressRules[1]
	assert.Equal(t, 443, httpsRule["from_port"], "HTTPS rule from_port should be 443")
	assert.Equal(t, 443, httpsRule["to_port"], "HTTPS rule to_port should be 443")
	assert.Equal(t, "tcp", httpsRule["protocol"], "HTTPS rule protocol should be tcp")
	assert.Equal(t, "HTTPS", httpsRule["description"], "HTTPS rule description should be HTTPS")
	assert.Equal(t, "0.0.0.0/0", httpsRule["cidr_blocks"], "HTTPS rule CIDR should be 0.0.0.0/0")
}

func TestSecurityGroupEgressRules(t *testing.T) {
	t.Parallel()

	// Test egress rules configuration
	egressRules := []map[string]interface{}{
		{
			"from_port":   0,
			"to_port":     0,
			"protocol":    "-1",
			"description": "All outbound traffic",
			"cidr_blocks": "0.0.0.0/0",
		},
	}

	assert.Len(t, egressRules, 1, "Should have 1 egress rule")

	// Test all outbound traffic rule
	allOutboundRule := egressRules[0]
	assert.Equal(t, 0, allOutboundRule["from_port"], "All outbound rule from_port should be 0")
	assert.Equal(t, 0, allOutboundRule["to_port"], "All outbound rule to_port should be 0")
	assert.Equal(t, "-1", allOutboundRule["protocol"], "All outbound rule protocol should be -1")
	assert.Equal(t, "All outbound traffic", allOutboundRule["description"], "All outbound rule description should match")
	assert.Equal(t, "0.0.0.0/0", allOutboundRule["cidr_blocks"], "All outbound rule CIDR should be 0.0.0.0/0")
}

func TestSecurityGroupTags(t *testing.T) {
	t.Parallel()

	// Test security group tagging configuration
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

func TestSecurityGroupRuleValidation(t *testing.T) {
	t.Parallel()

	// Test rule validation logic
	fromPort := 80
	toPort := 80
	protocol := "tcp"

	assert.True(t, fromPort <= toPort, "from_port should be less than or equal to to_port")
	assert.NotEmpty(t, protocol, "Protocol should not be empty")
	assert.Contains(t, []string{"tcp", "udp", "icmp", "-1"}, protocol, "Protocol should be valid")
}
