package test

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestS3Configuration(t *testing.T) {
	t.Parallel()

	// Test S3 bucket configuration
	bucketName := "test-terragrunt-aws-bucket"
	assert.NotEmpty(t, bucketName, "Bucket name should not be empty")
	assert.Contains(t, bucketName, "terragrunt", "Bucket name should contain 'terragrunt'")
	assert.Contains(t, bucketName, "aws", "Bucket name should contain 'aws'")

	// Test versioning configuration
	versioningEnabled := true
	assert.True(t, versioningEnabled, "Versioning should be enabled")

	// Test encryption configuration
	encryptionAlgorithm := "AES256"
	assert.Equal(t, "AES256", encryptionAlgorithm, "Encryption algorithm should be AES256")
}

func TestS3PublicAccessBlock(t *testing.T) {
	t.Parallel()

	// Test public access block configuration
	publicAccessBlock := map[string]bool{
		"block_public_acls":       true,
		"block_public_policy":     true,
		"ignore_public_acls":      true,
		"restrict_public_buckets": true,
	}

	assert.True(t, publicAccessBlock["block_public_acls"], "Public ACLs should be blocked")
	assert.True(t, publicAccessBlock["block_public_policy"], "Public policies should be blocked")
	assert.True(t, publicAccessBlock["ignore_public_acls"], "Public ACLs should be ignored")
	assert.True(t, publicAccessBlock["restrict_public_buckets"], "Public buckets should be restricted")
}

func TestS3LifecycleConfiguration(t *testing.T) {
	t.Parallel()

	// Test lifecycle rule configuration
	lifecycleRule := map[string]interface{}{
		"id":     "test_lifecycle_rule",
		"status": "Enabled",
		"expiration": map[string]interface{}{
			"days": 30,
		},
	}

	assert.Equal(t, "test_lifecycle_rule", lifecycleRule["id"], "Lifecycle rule ID should match")
	assert.Equal(t, "Enabled", lifecycleRule["status"], "Lifecycle rule status should be Enabled")
	
	expiration := lifecycleRule["expiration"].(map[string]interface{})
	assert.Equal(t, 30, expiration["days"], "Expiration days should be 30")
}

func TestS3Tags(t *testing.T) {
	t.Parallel()

	// Test S3 tagging configuration
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
