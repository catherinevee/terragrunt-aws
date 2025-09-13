# EKS Module - Variables

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where to create the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the EKS cluster will be deployed"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "cluster_endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses from"
  type        = string
  default     = null
}

variable "enable_irsa" {
  description = "Whether to create OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}

variable "cluster_encryption_config" {
  description = "Configuration block with encryption configuration for the cluster"
  type = object({
    provider_key_arn = string
    resources        = list(string)
  })
  default = null
}

variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logging to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "create_kms_key" {
  description = "Controls if a KMS key for cluster encryption should be created"
  type        = bool
  default     = true
}

variable "kms_key_deletion_window_in_days" {
  description = "The waiting period, specified in number of days"
  type        = number
  default     = 7
}

variable "kms_key_enable_default_policy" {
  description = "Specifies whether to enable the default key policy"
  type        = bool
  default     = true
}

variable "create_cloudwatch_log_group" {
  description = "Determines whether a log group is created by this module for the cluster logs"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "The number of days to retain log events in the log group"
  type        = number
  default     = 7
}

variable "create_cluster_security_group" {
  description = "Determines if a security group is created for the cluster"
  type        = bool
  default     = true
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group"
  type = map(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    type        = string
    cidr_blocks = list(string)
  }))
  default = {}
}

variable "create_node_security_group" {
  description = "Determines if a security group is created for the node groups"
  type        = bool
  default     = true
}

variable "node_security_group_additional_rules" {
  description = "List of additional security group rules to add to the node security group"
  type = map(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    type        = string
    cidr_blocks = list(string)
  }))
  default = {}
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type = map(object({
    name           = string
    instance_types = list(string)
    capacity_type  = string
    min_size       = number
    max_size       = number
    desired_size   = number
    disk_size      = number
    ami_type       = string
    platform       = string
    labels         = map(string)
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
    update_config = object({
      max_unavailable_percentage = number
    })
  }))
  default = {}
}

variable "fargate_profiles" {
  description = "Map of Fargate Profile definitions to create"
  type = map(object({
    name = string
    selectors = list(object({
      namespace = string
      labels    = map(string)
    }))
    subnet_ids = list(string)
    tags       = map(string)
  }))
  default = {}
}

variable "cluster_addons" {
  description = "Map of cluster addon configurations to enable for the cluster"
  type = map(object({
    addon_version               = string
    resolve_conflicts_on_create = string
    resolve_conflicts_on_update = string
  }))
  default = {
    coredns = {
      addon_version = "v1.10.1-eksbuild.1"
    }
    kube-proxy = {
      addon_version = "v1.28.1-eksbuild.1"
    }
    vpc-cni = {
      addon_version = "v1.14.1-eksbuild.1"
    }
    aws-ebs-csi-driver = {
      addon_version = "v1.20.0-eksbuild.1"
    }
  }
}

variable "cluster_access_entries" {
  description = "Map of cluster access entries to add to the cluster"
  type = map(object({
    kubernetes_groups = list(string)
    principal_arn     = string
    policy_associations = list(object({
      policy_arn = string
      access_scope = object({
        type       = string
        namespaces = list(string)
      })
    }))
  }))
  default = {}
}

variable "node_groups" {
  description = "Map of additional node groups to create"
  type = map(object({
    instance_type = string
    min_size      = number
    max_size      = number
    desired_size  = number
    disk_size     = number
    ami_type      = string
    platform      = string
    labels        = map(string)
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
  }))
  default = {}
}

variable "self_managed_node_groups" {
  description = "Map of self-managed node group definitions to create"
  type = map(object({
    instance_type = string
    min_size      = number
    max_size      = number
    desired_size  = number
    disk_size     = number
    ami_id        = string
    platform      = string
    labels        = map(string)
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
  }))
  default = {}
}

variable "create_oidc_provider" {
  description = "Create an OpenID Connect (OIDC) identity provider for the cluster"
  type        = bool
  default     = true
}

variable "cluster_addons_timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster addons"
  type = object({
    create = string
    update = string
    delete = string
  })
  default = {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

variable "eks_managed_node_group_defaults" {
  description = "Map of EKS managed node group default configurations"
  type = object({
    ami_type       = string
    capacity_type  = string
    disk_size      = number
    instance_types = list(string)
    platform       = string
  })
  default = {
    ami_type       = "AL2_x86_64"
    capacity_type  = "ON_DEMAND"
    disk_size      = 50
    instance_types = ["t3.medium"]
    platform       = "linux"
  }
}

variable "fargate_profile_defaults" {
  description = "Map of Fargate profile default configurations"
  type = object({
    platform_version = string
  })
  default = {
    platform_version = "LATEST"
  }
}

variable "self_managed_node_group_defaults" {
  description = "Map of self-managed node group default configurations"
  type = object({
    platform = string
  })
  default = {
    platform = "linux"
  }
}

variable "additional_addons" {
  description = "Map of additional EKS addons to install"
  type = map(object({
    version           = string
    resolve_conflicts = string
    preserve          = bool
  }))
  default = {}
}

variable "oidc_identity_providers" {
  description = "Map of OIDC identity providers to configure"
  type = map(object({
    client_id                     = string
    groups_claim                  = string
    groups_prefix                 = string
    identity_provider_config_name = string
    issuer_url                    = string
    required_claims               = map(string)
    username_claim                = string
    username_prefix               = string
  }))
  default = {}
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
