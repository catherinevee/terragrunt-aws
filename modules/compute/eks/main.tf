# EKS Module - Using official AWS EKS module from Terraform Registry

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = "${var.environment}-${var.name}"
  cluster_version = var.kubernetes_version

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  # EKS Managed Node Groups
  eks_managed_node_groups = var.eks_managed_node_groups

  # Fargate Profiles
  fargate_profiles = var.fargate_profiles

  # Cluster access entry
  cluster_access_entries = var.cluster_access_entries

  # Add-ons
  cluster_addons = var.cluster_addons

  # KMS key for EKS cluster encryption
  create_kms_key = var.create_kms_key
  kms_key_deletion_window_in_days = var.kms_key_deletion_window_in_days
  kms_key_enable_default_policy = var.kms_key_enable_default_policy

  # CloudWatch log group
  create_cloudwatch_log_group = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days

  # Cluster security group
  create_cluster_security_group = var.create_cluster_security_group
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules

  # Node security group
  create_node_security_group = var.create_node_security_group
  node_security_group_additional_rules = var.node_security_group_additional_rules

  # Tags
  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}"
      Type = "eks-cluster"
    }
  )

  # Cluster service ipv4 cidr
  cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr

  # Enable IRSA
  enable_irsa = var.enable_irsa

  # Cluster encryption config
  cluster_encryption_config = var.cluster_encryption_config

  # Cluster log types
  cluster_enabled_log_types = var.cluster_enabled_log_types

  # Node groups
  node_groups = var.node_groups

  # Self managed node groups
  self_managed_node_groups = var.self_managed_node_groups

  # OIDC identity provider
  create_oidc_provider = var.create_oidc_provider

  # Cluster addons
  cluster_addons_timeouts = var.cluster_addons_timeouts

  # EKS managed node group defaults
  eks_managed_node_group_defaults = var.eks_managed_node_group_defaults

  # Fargate profile defaults
  fargate_profile_defaults = var.fargate_profile_defaults

  # Self managed node group defaults
  self_managed_node_group_defaults = var.self_managed_node_group_defaults
}

# Additional EKS resources
resource "aws_eks_addon" "additional_addons" {
  for_each = var.additional_addons

  cluster_name = module.eks.cluster_name
  addon_name   = each.key
  addon_version = each.value.version

  resolve_conflicts = each.value.resolve_conflicts
  preserve          = each.value.preserve

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}-${each.key}"
    }
  )
}

# EKS Identity Provider Config
resource "aws_eks_identity_provider_config" "oidc" {
  for_each = var.oidc_identity_providers

  cluster_name = module.eks.cluster_name

  oidc {
    client_id                     = each.value.client_id
    groups_claim                  = each.value.groups_claim
    groups_prefix                 = each.value.groups_prefix
    identity_provider_config_name = each.value.identity_provider_config_name
    issuer_url                   = each.value.issuer_url
    required_claims               = each.value.required_claims
    username_claim                = each.value.username_claim
    username_prefix               = each.value.username_prefix
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}-oidc-${each.key}"
    }
  )
}
