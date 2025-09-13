provider "aws" {
  region = var.region
  
  # Default tags for all resources
  tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      ManagedBy   = "terraform"
      Module      = "vpc"
    }
  )
}
