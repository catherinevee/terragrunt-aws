# S3 Module - Using official AWS S3 module from Terraform Registry

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "${var.environment}-${var.name}-${random_string.bucket_suffix.result}"

  # Bucket configuration
  force_destroy             = var.force_destroy
  object_lock_enabled       = var.object_lock_enabled
  object_lock_configuration = var.object_lock_configuration

  # Versioning
  versioning = {
    enabled    = var.versioning_enabled
    mfa_delete = var.mfa_delete_enabled
  }

  # Server-side encryption
  server_side_encryption_configuration = var.server_side_encryption_configuration

  # Public access block
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  # Lifecycle configuration
  lifecycle_rule = var.lifecycle_rules

  # Intelligent tiering
  intelligent_tiering = var.intelligent_tiering

  # Logging
  logging = var.logging

  # Replication
  replication_configuration = var.replication_configuration

  # Notification
  notification = var.notification

  # Website configuration
  website = var.website

  # CORS configuration
  cors_rule = var.cors_rule

  # Tags
  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}"
      Type = "s3-bucket"
    }
  )
}

# Random string for bucket suffix to ensure uniqueness
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Additional S3 buckets if needed
resource "aws_s3_bucket" "additional" {
  for_each = var.additional_buckets

  bucket = "${var.environment}-${each.key}-${random_string.additional_bucket_suffix[each.key].result}"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${each.key}"
      Type = "s3-bucket"
    }
  )
}

resource "random_string" "additional_bucket_suffix" {
  for_each = var.additional_buckets
  length   = 8
  special  = false
  upper    = false
}

# S3 bucket policies
resource "aws_s3_bucket_policy" "bucket_policy" {
  for_each = var.bucket_policies

  bucket = module.s3_bucket.s3_bucket_id
  policy = each.value
}

resource "aws_s3_bucket_policy" "additional_bucket_policy" {
  for_each = var.additional_bucket_policies

  bucket = aws_s3_bucket.additional[each.key].id
  policy = each.value
}

# S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "bucket_pab" {
  for_each = var.additional_buckets

  bucket = aws_s3_bucket.additional[each.key].id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# S3 bucket versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  for_each = var.additional_buckets

  bucket = aws_s3_bucket.additional[each.key].id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# S3 bucket server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  for_each = var.additional_buckets

  bucket = aws_s3_bucket.additional[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}
