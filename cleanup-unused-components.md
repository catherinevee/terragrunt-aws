# Cleanup Unused Components

This document lists components that can be safely removed from the terragrunt-aws project.

## 🗑️ Components to Remove

### 1. Temporary Files (Root Directory)
```bash
# Remove temporary DynamoDB lock cleanup files
rm delete-lock.json
rm delete-locks-us-east-1-2.json
rm delete-locks-us-east-1-3.json
rm delete-locks-us-east-1-4.json
rm delete-locks-us-east-1.json
rm delete-locks-us-west-2.json
```

### 2. Outdated Documentation
```bash
# Remove outdated documentation
rm DEPLOYMENT-STATUS.md
rm TEST-CICD.md
```

### 3. Test Directory
```bash
# Remove entire test directory
rm -rf test/
```

### 4. Temp Directory
```bash
# Remove entire temp directory
rm -rf temp/
```

### 5. Unused Environment Directories
```bash
# Remove prod from us-east-1 (should only be in eu-west-1)
rm -rf environments/prod/us-east-1/

# Remove staging from us-east-1 (should only be in us-west-2)
rm -rf environments/staging/us-east-1/
```

### 6. Scripts Directory (Optional - Review First)
```bash
# These may be redundant with CI/CD pipeline
# Review before removing
rm -rf scripts/
```

## ✅ Components to Keep

### Core Infrastructure
- `environments/dev/us-east-1/` - Dev environment
- `environments/staging/us-west-2/` - Staging environment  
- `environments/prod/eu-west-1/` - Prod environment
- `modules/` - All Terraform modules
- `terragrunt.hcl` - Root configuration

### CI/CD Pipeline
- `.github/workflows/` - GitHub Actions workflows
- `docs/` - Documentation

### Documentation
- `README.md` - Main documentation
- `infrastructure-diagram.md` - Architecture diagrams
- `simple-infrastructure-diagram.md` - Simple diagrams
- `network-topology-diagram.md` - Network diagrams

### CLAUDE Files (Keep)
- `CLAUDE-overview.md` - Project overview
- `CLAUDE-terragrunt.md` - Terragrunt documentation

## 🧹 Cleanup Commands

### Safe Cleanup (Recommended)
```bash
# Remove temporary files
rm delete-lock*.json

# Remove outdated documentation
rm DEPLOYMENT-STATUS.md TEST-CICD.md

# Remove test and temp directories
rm -rf test/ temp/

# Remove unused environment directories
rm -rf environments/prod/us-east-1/
rm -rf environments/staging/us-east-1/
```

### Full Cleanup (Including Scripts)
```bash
# Run safe cleanup first
# Then remove scripts if CI/CD pipeline handles everything
rm -rf scripts/
```

## 📊 Space Savings

Removing these components will save approximately:
- **Temporary files**: ~2KB
- **Test directory**: ~1KB  
- **Temp directory**: ~1KB
- **Unused environments**: ~2KB
- **Scripts directory**: ~15KB
- **Outdated docs**: ~8KB

**Total**: ~29KB of unnecessary files

## ⚠️ Before Removing Scripts

Review if the scripts are still needed for:
- Local development
- Manual deployments
- Troubleshooting
- Documentation purposes

The CI/CD pipeline handles automated deployment, but scripts might be useful for local development or emergency manual deployments.
