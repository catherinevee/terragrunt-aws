# EKS configuration for dev environment in us-east-1

# Include the root configuration
include "root" {
  path = find_in_parent_folders()
}

# Include the environment configuration
include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

# Configure the S3 backend for this component
remote_state {
  backend = "s3"
  config = {
    bucket         = "terragrunt-${get_aws_account_id()}-state"
    key            = "dev/us-east-1/eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Define the Terraform module to use
terraform {
  source = "../../../..//modules/compute/eks"
}

# Define input variables for the EKS module
inputs = {
  environment = "dev"
  name        = "cluster"
  region      = "us-east-1"
  
  # VPC configuration
  vpc_id = dependency.vpc.outputs.vpc_id
  subnet_ids = concat(
    dependency.vpc.outputs.public_subnets,
    dependency.vpc.outputs.private_subnets
  )
  
  # Kubernetes version
  kubernetes_version = "1.28"
  
  # Cluster endpoint configuration
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  
  # EKS Managed Node Groups
  eks_managed_node_groups = {
    general = {
      name = "general"
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      min_size      = 1
      max_size      = 3
      desired_size  = 2
      disk_size     = 50
      ami_type      = "AL2_x86_64"
      platform      = "linux"
      
      labels = {
        role = "general"
      }
      
      update_config = {
        max_unavailable_percentage = 50
      }
    }
  }
  
  # Cluster addons
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
  
  # Enable IRSA
  enable_irsa = true
  
  # Cluster encryption
  cluster_encryption_config = {
    provider_key_arn = dependency.kms.outputs.key_arn
    resources        = ["secrets"]
  }
  
  # Enable cluster logging
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  
  # Create KMS key
  create_kms_key = true
  kms_key_deletion_window_in_days = 7
  kms_key_enable_default_policy = true
  
  # CloudWatch log group
  create_cloudwatch_log_group = true
  cloudwatch_log_group_retention_in_days = 7
  
  # Security groups
  create_cluster_security_group = true
  create_node_security_group = true
  
  # Common tags
  common_tags = {
    Environment = "dev"
    Terraform   = "true"
    ManagedBy   = "terragrunt"
    Project     = "terragrunt-aws"
  }
}

# Dependencies
dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    vpc_id = "vpc-mock"
    public_subnets = ["subnet-mock1", "subnet-mock2"]
    private_subnets = ["subnet-mock3", "subnet-mock4"]
  }
}

dependency "kms" {
  config_path = "../kms"
  
  mock_outputs = {
    key_arn = "arn:aws:kms:us-east-1:123456789012:key/mock-key-id"
  }
}
