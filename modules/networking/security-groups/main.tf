# Security Groups Module - Using official AWS Security Groups module from Terraform Registry

module "security_groups" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.environment}-${var.name}"
  description = var.description
  vpc_id      = var.vpc_id

  # Ingress rules
  ingress_with_cidr_blocks              = var.ingress_with_cidr_blocks
  ingress_with_source_security_group_id = var.ingress_with_source_security_group_id
  ingress_with_self                     = var.ingress_with_self

  # Egress rules
  egress_with_cidr_blocks              = var.egress_with_cidr_blocks
  egress_with_source_security_group_id = var.egress_with_source_security_group_id
  egress_with_self                     = var.egress_with_self

  # Additional rules
  computed_ingress_with_source_security_group_id = var.computed_ingress_with_source_security_group_id
  computed_egress_with_source_security_group_id  = var.computed_egress_with_source_security_group_id

  # Tags
  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}"
      Type = "security-group"
    }
  )
}

# Additional security groups if needed
resource "aws_security_group" "additional" {
  for_each = var.additional_security_groups

  name        = "${var.environment}-${each.key}"
  description = each.value.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = each.value.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${each.key}"
      Type = "security-group"
    }
  )
}
