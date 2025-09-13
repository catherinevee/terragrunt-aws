# S3 Module

This module creates S3 buckets with comprehensive security, lifecycle, and access control features using the official AWS S3 module from Terraform Registry.

## Features

- S3 buckets with configurable naming
- Server-side encryption (AES256 or KMS)
- Versioning and MFA delete protection
- Public access blocking
- Lifecycle policies for cost optimization
- Intelligent tiering for automatic optimization
- Access logging configuration
- Cross-region replication
- Website hosting
- CORS configuration
- Bucket policies

## Usage

```hcl
module "s3" {
  source = "../../modules/data/s3"
  
  environment = "dev"
  name        = "my-bucket"
  
  versioning_enabled = true
  force_destroy = false
  
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = true
    }
  }
  
  lifecycle_rules = [
    {
      id     = "transition_to_ia"
      status = "Enabled"
      enabled = true
      filter = {
        prefix = ""
      }
      transitions = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]
    }
  ]
  
  common_tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | The environment name | `string` | n/a | yes |
| name | Name of the S3 bucket | `string` | n/a | yes |
| force_destroy | A boolean that indicates all objects should be deleted from the bucket | `bool` | `false` | no |
| versioning_enabled | Enable versioning on the S3 bucket | `bool` | `true` | no |
| mfa_delete_enabled | Enable MFA delete on the S3 bucket | `bool` | `false` | no |
| server_side_encryption_configuration | Server-side encryption configuration | `object` | See variables.tf | no |
| block_public_acls | Whether Amazon S3 should block public ACLs for this bucket | `bool` | `true` | no |
| block_public_policy | Whether Amazon S3 should block public bucket policies for this bucket | `bool` | `true` | no |
| ignore_public_acls | Whether Amazon S3 should ignore public ACLs for this bucket | `bool` | `true` | no |
| restrict_public_buckets | Whether Amazon S3 should restrict public bucket policies for this bucket | `bool` | `true` | no |
| lifecycle_rules | List of lifecycle rules | `list(object)` | `[]` | no |
| intelligent_tiering | Map of intelligent tiering configurations | `map(object)` | `{}` | no |
| logging | Logging configuration | `object` | `null` | no |
| replication_configuration | Replication configuration | `object` | `null` | no |
| website | Website configuration | `object` | `null` | no |
| cors_rule | CORS configuration | `list(object)` | `[]` | no |
| common_tags | Common tags to be applied to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3_bucket_id | The name of the bucket |
| s3_bucket_arn | The ARN of the bucket |
| s3_bucket_domain_name | The bucket domain name |
| s3_bucket_regional_domain_name | The bucket region-specific domain name |
| s3_bucket_hosted_zone_id | The Route 53 Hosted Zone ID for this bucket's region |
| s3_bucket_website_endpoint | The website endpoint |
| s3_bucket_versioning_enabled | Whether versioning is enabled |
| s3_bucket_server_side_encryption_configuration_id | The server-side encryption configuration ID |
| s3_bucket_public_access_block_id | The public access block ID |
| s3_bucket_lifecycle_configuration_id | The lifecycle configuration ID |
| bucket_suffix | Random suffix used for bucket naming |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | ~> 5.0 |
| random | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |
| random | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [terraform-aws-modules/s3-bucket/aws](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws) | module |

## License

This module is licensed under the MIT License.
