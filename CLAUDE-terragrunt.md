
# anti-CLAUDE.md
## AI Code Assistant Anti-Patterns for Terraform & Terragrunt

This document defines Infrastructure as Code anti-patterns, shortcuts, and behaviors that AI code assistants MUST avoid when generating or modifying Terraform and Terragrunt code.

---

## 🚫 Terraform Resource Anti-Patterns

### 1. Hardcoded Values
**NEVER** hardcode environment-specific or sensitive values:
- ❌ `region = "us-east-1"` directly in resources
- ❌ `instance_type = "t2.micro"` without variables
- ❌ Account IDs, ARNs, or resource IDs as literals
- ❌ CIDR blocks as strings: `cidr_block = "10.0.0.0/16"`
- ❌ Hardcoded tags without using locals or variables
- ✅ Always use variables with proper descriptions and defaults
- ✅ Use data sources to fetch existing resource information

### 2. Missing Resource Dependencies
**NEVER** ignore implicit or explicit dependencies:
- ❌ Omitting `depends_on` when there's a non-obvious dependency
- ❌ Not using proper resource references: `vpc_id = "vpc-12345"`
- ❌ Creating resources without proper IAM roles/policies in place
- ❌ Ignoring lifecycle dependencies between resources
- ✅ Use resource attribute references: `vpc_id = aws_vpc.main.id`
- ✅ Explicitly declare dependencies when needed

### 3. Incomplete Resource Configuration
**NEVER** skip critical resource arguments:
- ❌ S3 buckets without encryption
- ❌ RDS instances without backup configuration
- ❌ Security groups without proper egress rules
- ❌ Resources without proper tagging strategy
- ❌ Load balancers without health checks
- ✅ Include all production-necessary configurations
- ✅ Follow AWS/Azure/GCP best practices for each resource

---

## 🚫 Terraform Structure Anti-Patterns

### 4. Monolithic Configuration
**NEVER** put everything in a single file:
- ❌ All resources in `main.tf`
- ❌ Variables, outputs, and resources mixed together
- ❌ No module separation for reusable components
- ❌ Single state file for entire infrastructure
- ✅ Organize code: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`
- ✅ Use modules for reusable components
- ✅ Implement proper state management strategy

### 5. Poor State Management
**NEVER** ignore state management best practices:
- ❌ Local state files for team projects
- ❌ No state locking configuration
- ❌ Shared state without proper backend configuration
- ❌ Manual state manipulation without backup
- ❌ Importing resources without documenting
- ✅ Always configure remote backend (S3, Azure Storage, GCS)
- ✅ Enable state locking with DynamoDB/Azure Storage/GCS
- ✅ Use workspace or separate states for environments

### 6. Version Constraints Violations
**NEVER** ignore version pinning:
- ❌ No `required_version` for Terraform
- ❌ Missing provider version constraints
- ❌ Using `latest` or no version for module sources
- ❌ Not specifying `required_providers` block
```hcl
# ❌ BAD
provider "aws" {}

# ✅ GOOD
terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

---

## 🚫 Terragrunt Anti-Patterns

### 7. DRY Violations in Terragrunt
**NEVER** repeat configuration across environments:
- ❌ Copying entire configs between env folders
- ❌ Not using `terragrunt.hcl` inheritance
- ❌ Hardcoding backend configs in each environment
- ❌ Duplicating provider configurations
- ✅ Use parent `terragrunt.hcl` for common configuration
- ✅ Leverage `include` blocks properly
- ✅ Use `inputs` for environment-specific values

### 8. Incorrect Dependency Management
**NEVER** misconfigure Terragrunt dependencies:
- ❌ Missing `dependency` blocks for cross-module references
- ❌ Circular dependencies between modules
- ❌ Not using `mock_outputs` for plan operations
- ❌ Hardcoding outputs from other modules
```hcl
# ❌ BAD
inputs = {
  vpc_id = "vpc-12345"
}

# ✅ GOOD
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "vpc-mock"
  }
}
inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
}
```

### 9. Poor Terragrunt Structure
**NEVER** ignore Terragrunt organizational patterns:
- ❌ Flat directory structure without environment separation
- ❌ No consistent naming convention for directories
- ❌ Missing `_envcommon` patterns for shared configs
- ❌ Not using `find_in_parent_folders()`
- ✅ Implement proper directory hierarchy
- ✅ Use environment-based folder structure

---

## 🚫 Security Anti-Patterns

### 10. Insecure Defaults
**NEVER** use insecure configurations:
- ❌ `0.0.0.0/0` in security group ingress rules without justification
- ❌ IAM policies with `"*"` resources unnecessarily
- ❌ Unencrypted storage resources (S3, EBS, RDS)
- ❌ Passwords or secrets in plain text variables
- ❌ Public accessibility on resources that should be private
```hcl
# ❌ BAD
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# ✅ GOOD
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = var.allowed_ssh_cidrs  # Explicitly defined list
}
```

### 11. Sensitive Data Exposure
**NEVER** expose sensitive information:
- ❌ Secrets in terraform outputs without `sensitive = true`
- ❌ Logging sensitive variable values
- ❌ Storing secrets in tfvars files in version control
- ❌ Using plain text for database passwords
- ✅ Use AWS Secrets Manager, Azure Key Vault, or GCP Secret Manager
- ✅ Mark sensitive outputs and variables appropriately

---

## 🚫 Module Anti-Patterns

### 12. Non-Reusable Modules
**NEVER** create tightly coupled modules:
- ❌ Modules with hardcoded resource names
- ❌ Environment-specific logic inside modules
- ❌ Modules without configurable variables
- ❌ No `README.md` or `examples/` directory
- ❌ Missing input validation
```hcl
# ❌ BAD
resource "aws_s3_bucket" "bucket" {
  bucket = "my-company-prod-bucket"  # Hardcoded
}

# ✅ GOOD
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Bucket name must be valid S3 bucket name."
  }
}
```

### 13. Poor Module Versioning
**NEVER** use modules without version control:
- ❌ Local file paths for team modules
- ❌ Git references without tags/releases
- ❌ Using `master` or `main` branch directly
- ❌ No semantic versioning for module releases
```hcl
# ❌ BAD
module "vpc" {
  source = "git::https://github.com/org/modules.git//vpc"
}

# ✅ GOOD
module "vpc" {
  source  = "git::https://github.com/org/modules.git//vpc?ref=v1.2.3"
}
```

---

## 🚫 Data Source Anti-Patterns

### 14. Inefficient Data Source Usage
**NEVER** misuse data sources:
- ❌ Using data sources for resources managed in same configuration
- ❌ Not caching frequently used data source results
- ❌ Multiple identical data source queries
- ❌ Data sources without proper filters
```hcl
# ❌ BAD - Multiple identical queries
data "aws_ami" "ubuntu1" { ... }
data "aws_ami" "ubuntu2" { ... }  # Same filters

# ✅ GOOD - Single query, reused
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-*"]
  }
}
```

---

## 🚫 Loop and Conditional Anti-Patterns

### 15. Improper Loop Usage
**NEVER** misuse Terraform meta-arguments:
- ❌ Using `count` when `for_each` is more appropriate
- ❌ Not handling empty sets in `for_each`
- ❌ Complex logic in resource blocks instead of locals
- ❌ Forgetting that `count.index` starts at 0
```hcl
# ❌ BAD
resource "aws_instance" "web" {
  count = var.create_instance ? 1 : 0
  # Problems when adding/removing instances
}

# ✅ GOOD
resource "aws_instance" "web" {
  for_each = var.instances  # Map of instance configurations
  
  instance_type = each.value.instance_type
  ami          = each.value.ami
}
```

---

## 🚫 Output and Variable Anti-Patterns

### 16. Poor Variable Definitions
**NEVER** create ambiguous variables:
- ❌ Variables without descriptions
- ❌ No type constraints on complex variables
- ❌ Missing default values when appropriate
- ❌ No validation rules for constrained inputs
```hcl
# ❌ BAD
variable "subnets" {}

# ✅ GOOD
variable "subnets" {
  description = "Map of subnet configurations"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = bool
  }))
  
  validation {
    condition     = alltrue([for s in var.subnets : can(cidrhost(s.cidr_block, 0))])
    error_message = "All subnet CIDR blocks must be valid."
  }
}
```

---

## 📋 Terraform/Terragrunt Checklist

Before generating or modifying IaC code, ensure:

- [ ] No hardcoded environment-specific values
- [ ] Remote backend configured with state locking
- [ ] All providers and modules version-pinned
- [ ] Resources properly reference each other (no hardcoded IDs)
- [ ] Security best practices followed (encryption, least privilege)
- [ ] Proper file organization (separate .tf files by purpose)
- [ ] Variables have descriptions, types, and validation
- [ ] Sensitive data properly managed (not in tfvars)
- [ ] Modules are reusable and properly documented
- [ ] Terragrunt DRY principle followed
- [ ] Dependencies explicitly declared
- [ ] No `0.0.0.0/0` without explicit requirement
- [ ] For_each preferred over count where appropriate
- [ ] Data sources used efficiently
- [ ] Proper tagging strategy implemented

---

## 🎯 Core IaC Principles

1. **Declarative over Imperative**: Define desired state, not steps
2. **DRY (Don't Repeat Yourself)**: Use modules and Terragrunt
3. **Immutable Infrastructure**: Replace, don't modify
4. **Version Everything**: Pin all versions explicitly
5. **Secure by Default**: Never compromise security for convenience
6. **Environment Parity**: Use same code across environments
7. **State Awareness**: Always consider state implications

---

## 🛠️ Required Patterns to Follow

### Always Include These Files:
```
module/
├── main.tf          # Primary resources
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── versions.tf      # Version constraints
├── README.md        # Documentation
└── examples/        # Usage examples
```

### Always Use This Variable Pattern:
```hcl
variable "example" {
  description = "Clear description of purpose"
  type        = string  # Always specify type
  default     = null    # Default only if sensible
  
  validation {
    condition     = can(regex("^[pattern]$", var.example))
    error_message = "Helpful error message."
  }
}
```

---

*This document ensures AI assistants generate production-ready, secure, and maintainable Terraform and Terragrunt code following infrastructure as code best practices.*