# CloudFront Module - Variables

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "name" {
  description = "Name of the CloudFront distribution"
  type        = string
}

variable "is_ipv6_enabled" {
  description = "Whether IPv6 is enabled"
  type        = bool
  default     = true
}

variable "price_class" {
  description = "Price class for the distribution"
  type        = string
  default     = "PriceClass_100"
}

variable "http_version" {
  description = "HTTP version for the distribution"
  type        = string
  default     = "http2"
}

variable "comment" {
  description = "Comment for the distribution"
  type        = string
  default     = "CloudFront distribution managed by Terraform"
}

variable "default_root_object" {
  description = "Default root object for the distribution"
  type        = string
  default     = "index.html"
}

variable "origins" {
  description = "List of origins for the distribution"
  type = list(object({
    domain_name = string
    origin_id   = string
    origin_path = string
    custom_origin_config = object({
      http_port              = number
      https_port             = number
      origin_protocol_policy = string
      origin_ssl_protocols   = list(string)
    })
    s3_origin_config = object({
      origin_access_identity = string
    })
  }))
  default = []
}

variable "default_cache_behavior" {
  description = "Default cache behavior for the distribution"
  type = object({
    target_origin_id       = string
    viewer_protocol_policy = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    compress               = bool
    forwarded_values = object({
      query_string = bool
      cookies = object({
        forward = string
      })
    })
  })
  default = {
    target_origin_id       = ""
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    forwarded_values = {
      query_string = false
      cookies = {
        forward = "none"
      }
    }
  }
}

variable "ordered_cache_behaviors" {
  description = "List of ordered cache behaviors for the distribution"
  type = list(object({
    path_pattern           = string
    target_origin_id       = string
    viewer_protocol_policy = string
    allowed_methods        = list(string)
    cached_methods         = list(string)
    compress               = bool
    forwarded_values = object({
      query_string = bool
      cookies = object({
        forward = string
      })
    })
  }))
  default = []
}

variable "custom_error_responses" {
  description = "List of custom error responses for the distribution"
  type = list(object({
    error_code         = number
    response_code      = number
    response_page_path = string
  }))
  default = []
}

variable "geo_restriction" {
  description = "Geo restriction configuration for the distribution"
  type = object({
    restriction_type = string
    locations        = list(string)
  })
  default = {
    restriction_type = "none"
    locations        = []
  }
}

variable "viewer_certificate" {
  description = "Viewer certificate configuration for the distribution"
  type = object({
    cloudfront_default_certificate = bool
    acm_certificate_arn            = string
    ssl_support_method             = string
    minimum_protocol_version       = string
  })
  default = {
    cloudfront_default_certificate = true
    acm_certificate_arn            = ""
    ssl_support_method             = ""
    minimum_protocol_version       = ""
  }
}

variable "logging_config" {
  description = "Logging configuration for the distribution"
  type = object({
    bucket          = string
    prefix          = string
    include_cookies = bool
  })
  default = null
}

variable "web_acl_id" {
  description = "Web ACL ID for the distribution"
  type        = string
  default     = null
}

variable "aliases" {
  description = "List of aliases for the distribution"
  type        = list(string)
  default     = []
}

variable "additional_distributions" {
  description = "Map of additional CloudFront distributions to create"
  type = map(object({
    enabled             = bool
    is_ipv6_enabled     = bool
    price_class         = string
    http_version        = string
    comment             = string
    default_root_object = string
    origins = list(object({
      domain_name = string
      origin_id   = string
      origin_path = string
      custom_origin_config = object({
        http_port              = number
        https_port             = number
        origin_protocol_policy = string
        origin_ssl_protocols   = list(string)
      })
      s3_origin_config = object({
        origin_access_identity = string
      })
    }))
    default_cache_behavior = object({
      target_origin_id       = string
      viewer_protocol_policy = string
      allowed_methods        = list(string)
      cached_methods         = list(string)
      compress               = bool
      forwarded_values = object({
        query_string = bool
        cookies = object({
          forward = string
        })
      })
    })
    geo_restriction = object({
      restriction_type = string
      locations        = list(string)
    })
    viewer_certificate = object({
      cloudfront_default_certificate = bool
      acm_certificate_arn            = string
      ssl_support_method             = string
      minimum_protocol_version       = string
    })
    aliases = list(string)
  }))
  default = {}
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
