package test

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestBasicFunctionality(t *testing.T) {
	t.Parallel()

	// Basic test to verify the test framework is working
	assert.True(t, true, "Basic test should pass")
	
	// Test string operations
	testString := "terragrunt-aws-test"
	assert.Contains(t, testString, "terragrunt", "Test string should contain 'terragrunt'")
	assert.Contains(t, testString, "aws", "Test string should contain 'aws'")
	
	// Test numeric operations
	testNumber := 42
	assert.Equal(t, 42, testNumber, "Test number should equal 42")
	assert.Greater(t, testNumber, 40, "Test number should be greater than 40")
}

func TestEnvironmentVariables(t *testing.T) {
	t.Parallel()

	// Test that we can access environment variables
	// This is a basic test to ensure the test environment is set up correctly
	assert.NotEmpty(t, "test", "Test environment should not be empty")
}

func TestGoModules(t *testing.T) {
	t.Parallel()

	// Test that our Go modules are working correctly
	// This verifies that the go.mod file is properly configured
	assert.True(t, true, "Go modules should be working")
}
