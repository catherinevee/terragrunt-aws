package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestS3Module(t *testing.T) {
	t.Parallel()

	// AWS region to test in
	awsRegion := "us-east-1"

	// Terraform options for the S3 module
	terraformOptions := &terraform.Options{
		// Path to the S3 module
		TerraformDir: "../modules/data/s3",

		// Variables to pass to the module
		Vars: map[string]interface{}{
			"bucket": "test-terragrunt-aws-bucket",
			"versioning": map[string]interface{}{
				"enabled": true,
			},
			"server_side_encryption_configuration": map[string]interface{}{
				"rule": map[string]interface{}{
					"apply_server_side_encryption_by_default": map[string]interface{}{
						"sse_algorithm": "AES256",
					},
				},
			},
			"public_access_block": map[string]interface{}{
				"block_public_acls":       true,
				"block_public_policy":     true,
				"ignore_public_acls":      true,
				"restrict_public_buckets": true,
			},
			"lifecycle_rule": []map[string]interface{}{
				{
					"id":     "test_lifecycle_rule",
					"status": "Enabled",
					"expiration": map[string]interface{}{
						"days": 30,
					},
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

	// Get the S3 bucket name
	bucketName := terraform.Output(t, terraformOptions, "s3_bucket_id")
	assert.NotEmpty(t, bucketName, "S3 bucket name should not be empty")

	// Get the S3 bucket ARN
	bucketArn := terraform.Output(t, terraformOptions, "s3_bucket_arn")
	assert.NotEmpty(t, bucketArn, "S3 bucket ARN should not be empty")

	// Verify S3 bucket exists in AWS
	bucket := aws.GetS3Bucket(t, awsRegion, bucketName)
	assert.NotNil(t, bucket, "S3 bucket should exist")

	// Verify bucket versioning is enabled
	versioning := aws.GetS3BucketVersioning(t, awsRegion, bucketName)
	assert.Equal(t, "Enabled", versioning, "S3 bucket versioning should be enabled")

	// Verify bucket encryption is configured
	encryption := aws.GetS3BucketEncryption(t, awsRegion, bucketName)
	assert.NotNil(t, encryption, "S3 bucket encryption should be configured")

	// Verify public access block is configured
	publicAccessBlock := aws.GetS3BucketPublicAccessBlock(t, awsRegion, bucketName)
	assert.True(t, *publicAccessBlock.BlockPublicAcls, "Public ACLs should be blocked")
	assert.True(t, *publicAccessBlock.BlockPublicPolicy, "Public policies should be blocked")
	assert.True(t, *publicAccessBlock.IgnorePublicAcls, "Public ACLs should be ignored")
	assert.True(t, *publicAccessBlock.RestrictPublicBuckets, "Public buckets should be restricted")

	// Verify bucket lifecycle configuration
	lifecycle := aws.GetS3BucketLifecycleConfiguration(t, awsRegion, bucketName)
	assert.NotNil(t, lifecycle, "S3 bucket lifecycle should be configured")
	assert.Len(t, lifecycle.Rules, 1, "Should have 1 lifecycle rule")
	assert.Equal(t, "test_lifecycle_rule", *lifecycle.Rules[0].ID, "Lifecycle rule ID should match")
	assert.Equal(t, "Enabled", *lifecycle.Rules[0].Status, "Lifecycle rule should be enabled")
}
