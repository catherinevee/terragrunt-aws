# EKS Module

This module creates an Amazon EKS cluster with managed node groups, Fargate profiles, and add-ons using the official AWS EKS module from Terraform Registry.

## Features

- EKS cluster with configurable Kubernetes version
- EKS managed node groups with auto-scaling
- Fargate profiles for serverless workloads
- Cluster add-ons (CoreDNS, kube-proxy, VPC CNI, EBS CSI driver)
- IAM Roles for Service Accounts (IRSA)
- KMS encryption for cluster secrets
- CloudWatch logging
- Security groups for cluster and nodes
- OIDC identity provider

## Usage

```hcl
module "eks" {
  source = "../../modules/compute/eks"
  
  environment = "dev"
  name        = "cluster"
  
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  
  kubernetes_version = "1.28"
  
  eks_managed_node_groups = {
    general = {
      name = "general"
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      min_size      = 1
      max_size      = 3
      desired_size  = 2
    }
  }
  
  cluster_addons = {
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
  
  enable_irsa = true
  
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
| name | Name of the EKS cluster | `string` | n/a | yes |
| vpc_id | ID of the VPC where to create the EKS cluster | `string` | n/a | yes |
| subnet_ids | List of subnet IDs where the EKS cluster will be deployed | `list(string)` | n/a | yes |
| kubernetes_version | Kubernetes version | `string` | `"1.28"` | no |
| cluster_endpoint_public_access | Whether the Amazon EKS public API server endpoint is enabled | `bool` | `true` | no |
| cluster_endpoint_private_access | Whether the Amazon EKS private API server endpoint is enabled | `bool` | `true` | no |
| enable_irsa | Whether to create OpenID Connect Provider for EKS to enable IRSA | `bool` | `true` | no |
| create_kms_key | Controls if a KMS key for cluster encryption should be created | `bool` | `true` | no |
| cluster_encryption_config | Configuration block with encryption configuration for the cluster | `object` | `null` | no |
| cluster_enabled_log_types | A list of the desired control plane logging to enable | `list(string)` | `["api", "audit", "authenticator", "controllerManager", "scheduler"]` | no |
| eks_managed_node_groups | Map of EKS managed node group definitions to create | `map(object)` | `{}` | no |
| fargate_profiles | Map of Fargate Profile definitions to create | `map(object)` | `{}` | no |
| cluster_addons | Map of cluster addon configurations to enable for the cluster | `map(object)` | See variables.tf | no |
| common_tags | Common tags to be applied to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | The name/id of the EKS cluster |
| cluster_arn | The Amazon Resource Name (ARN) of the cluster |
| cluster_endpoint | Endpoint for EKS control plane |
| cluster_oidc_issuer_url | The URL on the EKS cluster for the OpenID Connect identity provider |
| cluster_security_group_id | Security group ID attached to the EKS cluster |
| cluster_version | The Kubernetes server version for the EKS cluster |
| eks_managed_node_groups | Map of attribute maps for all EKS managed node groups created |
| fargate_profiles | Map of attribute maps for all EKS Fargate profiles created |
| cluster_addons | Map of attribute maps for all EKS cluster addons created |
| cloudwatch_log_group_name | Name of cloudwatch log group created |
| kms_key_id | The globally unique identifier for the key |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [terraform-aws-modules/eks/aws](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws) | module |

## License

This module is licensed under the MIT License.
