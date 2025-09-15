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

	// Generate a unique bucket name
	bucketName := "test-terragrunt-aws-bucket-12345"

	// Terraform options for the S3 module
	terraformOptions := &terraform.Options{
		// Path to the S3 module
		TerraformDir: "../modules/data/s3",
		// Use local backend for testing
		BackendConfig: map[string]interface{}{
			"backend": "local",
		},

		// Variables to pass to the module
		Vars: map[string]interface{}{
			"environment": "test",
			"name":        bucketName,
			"versioning_enabled": true,
			"server_side_encryption_configuration": map[string]interface{}{
				"rule": map[string]interface{}{
					"apply_server_side_encryption_by_default": map[string]interface{}{
						"sse_algorithm":     "AES256",
						"kms_master_key_id": nil,
					},
					"bucket_key_enabled": true,
				},
			},
			"block_public_acls":       true,
			"block_public_policy":     true,
			"ignore_public_acls":      true,
			"restrict_public_buckets": true,
			"lifecycle_rules": []map[string]interface{}{
				{
					"id":      "test_lifecycle_rule",
					"status":  "Enabled",
					"enabled": true,
					"filter": map[string]interface{}{
						"prefix": "",
						"tags":   map[string]string{},
					},
					"expiration": map[string]interface{}{
						"days": 30,
					},
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

	// Get the S3 bucket name
	actualBucketName := terraform.Output(t, terraformOptions, "s3_bucket_id")
	assert.NotEmpty(t, actualBucketName, "S3 bucket name should not be empty")

	// Get the S3 bucket ARN
	bucketArn := terraform.Output(t, terraformOptions, "s3_bucket_arn")
	assert.NotEmpty(t, bucketArn, "S3 bucket ARN should not be empty")

	// Verify bucket exists using AWS API
	aws.AssertS3BucketExists(t, awsRegion, actualBucketName)

	// Verify bucket versioning is enabled
	versioning := aws.GetS3BucketVersioning(t, awsRegion, actualBucketName)
	assert.Equal(t, "Enabled", versioning, "S3 bucket versioning should be enabled")

	// Verify bucket policy exists
	aws.AssertS3BucketPolicyExists(t, awsRegion, actualBucketName)

	// Verify bucket versioning exists
	aws.AssertS3BucketVersioningExists(t, awsRegion, actualBucketName)
}
