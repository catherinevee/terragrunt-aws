# Simple Terragrunt AWS Infrastructure Diagram

A simplified view of the terragrunt-aws infrastructure architecture.

## Core Infrastructure Overview

```mermaid
graph TB
    subgraph "Multi-Region AWS Infrastructure"
        
        subgraph "US East 1 - Dev"
            VPC1[VPC<br/>10.2.0.0/16]
            EKS1[EKS Cluster]
            RDS1[RDS Aurora]
            S31[S3 Buckets]
        end
        
        subgraph "US West 2 - Staging"
            VPC2[VPC<br/>10.2.0.0/16]
            EKS2[EKS Cluster]
            RDS2[RDS Aurora]
            S32[S3 Buckets]
        end
        
        subgraph "EU West 1 - Prod"
            VPC3[VPC<br/>10.3.0.0/16]
            EKS3[EKS Cluster]
            RDS3[RDS Aurora]
            S33[S3 Buckets]
        end
    end

    subgraph "CI/CD Pipeline"
        GH[GitHub]
        GA[GitHub Actions]
        TG[Terragrunt]
        TF[Terraform]
    end

    subgraph "State Management"
        S3_STATE[S3 State Buckets]
        DDB[DynamoDB Tables]
    end

    subgraph "Terraform Registry"
        TFR[Official AWS Modules]
    end

    GH --> GA
    GA --> TG
    TG --> TF
    TF --> TFR
    TFR --> VPC1
    TFR --> VPC2
    TFR --> VPC3
    TF --> S3_STATE
    TF --> DDB

    classDef regionStyle fill:#e3f2fd,stroke:#1976d2,stroke-width:3px
    classDef cicdStyle fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef stateStyle fill:#e8f5e8,stroke:#388e3c,stroke-width:2px
    classDef tfrStyle fill:#fff3e0,stroke:#f57c00,stroke-width:2px

    class VPC1,EKS1,RDS1,S31,VPC2,EKS2,RDS2,S32,VPC3,EKS3,RDS3,S33 regionStyle
    class GH,GA,TG,TF cicdStyle
    class S3_STATE,DDB stateStyle
    class TFR tfrStyle
```

## Module Dependencies

```mermaid
graph LR
    subgraph "Terragrunt Environments"
        DEV[dev/us-east-1]
        STAGING[staging/us-west-2]
        PROD[prod/eu-west-1]
    end

    subgraph "Core Modules"
        VPC[VPC Module]
        EKS[EKS Module]
        RDS[RDS Module]
        S3[S3 Module]
        IAM[IAM Module]
        KMS[KMS Module]
    end

    subgraph "Terraform Registry"
        TFR[terraform-aws-modules]
    end

    DEV --> VPC
    STAGING --> VPC
    PROD --> VPC

    VPC --> EKS
    VPC --> RDS
    VPC --> S3

    EKS --> IAM
    RDS --> KMS
    S3 --> IAM

    VPC --> TFR
    EKS --> TFR
    RDS --> TFR
    S3 --> TFR
    IAM --> TFR
    KMS --> TFR

    classDef envStyle fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef moduleStyle fill:#f1f8e9,stroke:#2e7d32,stroke-width:2px
    classDef tfrStyle fill:#fff8e1,stroke:#f57f17,stroke-width:2px

    class DEV,STAGING,PROD envStyle
    class VPC,EKS,RDS,S3,IAM,KMS moduleStyle
    class TFR tfrStyle
```

## Deployment Flow

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant GH as GitHub
    participant GA as GitHub Actions
    participant TG as Terragrunt
    participant TF as Terraform
    participant TFR as Terraform Registry
    participant AWS as AWS

    Dev->>GH: Push code to main
    GH->>GA: Trigger CI/CD pipeline
    GA->>TG: Run terragrunt commands
    TG->>TF: Execute terraform
    TF->>TFR: Download modules
    TFR-->>TF: Return module code
    TF->>AWS: Deploy infrastructure
    AWS-->>TF: Confirm deployment
    TF-->>TG: Return status
    TG-->>GA: Return status
    GA-->>GH: Update status
    GH-->>Dev: Notify completion
```

## Key Components

- **3 AWS Regions**: us-east-1, us-west-2, eu-west-1
- **3 Environments**: dev, staging, prod
- **Terraform Registry**: All modules from official AWS modules
- **State Management**: S3 + DynamoDB for locking
- **CI/CD**: GitHub Actions automation
- **Infrastructure**: VPC, EKS, RDS, S3, IAM, KMS
