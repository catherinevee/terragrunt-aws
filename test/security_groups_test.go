package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestSecurityGroupsModule(t *testing.T) {
	t.Parallel()

	// AWS region to test in
	awsRegion := "us-east-1"

	// Terraform options for the Security Groups module
	terraformOptions := &terraform.Options{
		// Path to the Security Groups module
		TerraformDir: "../modules/networking/security-groups",

		// Variables to pass to the module
		Vars: map[string]interface{}{
			"name":        "test-security-group",
			"description": "Test security group for Terratest",
			"vpc_id":      "vpc-12345678", // This would be replaced with actual VPC ID in real tests
			"ingress_with_cidr_blocks": []map[string]interface{}{
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
			},
			"egress_with_cidr_blocks": []map[string]interface{}{
				{
					"from_port":   0,
					"to_port":     0,
					"protocol":    "-1",
					"description": "All outbound traffic",
					"cidr_blocks": "0.0.0.0/0",
				},
			},
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

	// Get the security group ID
	securityGroupId := terraform.Output(t, terraformOptions, "security_group_id")
	assert.NotEmpty(t, securityGroupId, "Security group ID should not be empty")

	// Get the security group ARN
	securityGroupArn := terraform.Output(t, terraformOptions, "security_group_arn")
	assert.NotEmpty(t, securityGroupArn, "Security group ARN should not be empty")

	// Verify security group exists in AWS
	securityGroup := aws.GetSecurityGroup(t, awsRegion, securityGroupId)
	assert.NotNil(t, securityGroup, "Security group should exist")
	assert.Equal(t, "test-security-group", *securityGroup.GroupName, "Security group name should match")
	assert.Equal(t, "Test security group for Terratest", *securityGroup.Description, "Security group description should match")

	// Verify ingress rules
	ingressRules := securityGroup.IpPermissions
	assert.Len(t, ingressRules, 2, "Should have 2 ingress rules")

	// Check HTTP rule (port 80)
	httpRule := findSecurityGroupRule(ingressRules, 80, 80, "tcp")
	assert.NotNil(t, httpRule, "HTTP rule should exist")
	assert.Equal(t, "HTTP", *httpRule.UserIdGroupPairs[0].Description, "HTTP rule description should match")

	// Check HTTPS rule (port 443)
	httpsRule := findSecurityGroupRule(ingressRules, 443, 443, "tcp")
	assert.NotNil(t, httpsRule, "HTTPS rule should exist")
	assert.Equal(t, "HTTPS", *httpsRule.UserIdGroupPairs[0].Description, "HTTPS rule description should match")

	// Verify egress rules
	egressRules := securityGroup.IpPermissionsEgress
	assert.Len(t, egressRules, 1, "Should have 1 egress rule")

	// Check all outbound traffic rule
	allOutboundRule := findSecurityGroupRule(egressRules, 0, 0, "-1")
	assert.NotNil(t, allOutboundRule, "All outbound rule should exist")
	assert.Equal(t, "All outbound traffic", *allOutboundRule.UserIdGroupPairs[0].Description, "All outbound rule description should match")
}

// Helper function to find a specific security group rule
func findSecurityGroupRule(rules []*aws.SecurityGroupRule, fromPort, toPort int64, protocol string) *aws.SecurityGroupRule {
	for _, rule := range rules {
		if *rule.FromPort == fromPort && *rule.ToPort == toPort && *rule.IpProtocol == protocol {
			return rule
		}
	}
	return nil
}
