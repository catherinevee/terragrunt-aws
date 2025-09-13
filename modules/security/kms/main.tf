# KMS Module - Using official AWS KMS module from Terraform Registry

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.0"

  # KMS Key
  key = {
    description = var.description
    deletion_window_in_days = var.deletion_window_in_days
    enable_key_rotation = var.enable_key_rotation
    policy = var.policy
    multi_region = var.multi_region
  }

  # KMS Alias
  aliases = var.aliases

  # KMS Key Policy
  key_policy = var.key_policy

  # KMS Grants
  grants = var.grants

  # Tags
  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}"
      Type = "kms-key"
    }
  )
}

# Additional KMS resources
resource "aws_kms_key" "additional" {
  for_each = var.additional_keys

  description             = each.value.description
  deletion_window_in_days = each.value.deletion_window_in_days
  enable_key_rotation     = each.value.enable_key_rotation
  policy                  = each.value.policy
  multi_region           = each.value.multi_region

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "kms-key"
    }
  )
}

resource "aws_kms_alias" "additional" {
  for_each = var.additional_aliases

  name          = each.key
  target_key_id = each.value.target_key_id
}

resource "aws_kms_grant" "additional" {
  for_each = var.additional_grants

  name              = each.key
  key_id            = each.value.key_id
  grantee_principal = each.value.grantee_principal
  operations        = each.value.operations
  constraints = each.value.constraints
}

resource "aws_kms_replica_key" "additional" {
  for_each = var.additional_replica_keys

  description = each.value.description
  primary_key_arn = each.value.primary_key_arn
  policy = each.value.policy

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "kms-replica-key"
    }
  )
}

resource "aws_kms_external_key" "additional" {
  for_each = var.additional_external_keys

  description = each.value.description
  deletion_window_in_days = each.value.deletion_window_in_days
  policy = each.value.policy
  key_material_base64 = each.value.key_material_base64
  valid_to = each.value.valid_to

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "kms-external-key"
    }
  )
}
