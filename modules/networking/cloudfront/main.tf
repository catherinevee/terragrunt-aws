# CloudFront Module - Using official AWS CloudFront module from Terraform Registry

module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 3.0"

  # CloudFront Distribution
  distribution = {
    enabled             = true
    is_ipv6_enabled     = var.is_ipv6_enabled
    price_class         = var.price_class
    http_version        = var.http_version
    comment             = var.comment
    default_root_object = var.default_root_object

    # Origins
    origins = var.origins

    # Default cache behavior
    default_cache_behavior = var.default_cache_behavior

    # Additional cache behaviors
    ordered_cache_behaviors = var.ordered_cache_behaviors

    # Custom error responses
    custom_error_responses = var.custom_error_responses

    # Geo restrictions
    geo_restriction = var.geo_restriction

    # Viewer certificate
    viewer_certificate = var.viewer_certificate

    # Logging
    logging_config = var.logging_config

    # Web ACL
    web_acl_id = var.web_acl_id

    # Aliases
    aliases = var.aliases

    # Tags
    tags = merge(
      var.common_tags,
      {
        Name = "${var.environment}-${var.name}"
        Type = "cloudfront-distribution"
      }
    )
  }
}

# Additional CloudFront resources
resource "aws_cloudfront_distribution" "additional" {
  for_each = var.additional_distributions

  enabled             = each.value.enabled
  is_ipv6_enabled     = each.value.is_ipv6_enabled
  price_class         = each.value.price_class
  http_version        = each.value.http_version
  comment             = each.value.comment
  default_root_object = each.value.default_root_object

  # Origins
  dynamic "origin" {
    for_each = each.value.origins
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = origin.value.origin_path

      custom_origin_config {
        http_port              = origin.value.custom_origin_config.http_port
        https_port             = origin.value.custom_origin_config.https_port
        origin_protocol_policy = origin.value.custom_origin_config.origin_protocol_policy
        origin_ssl_protocols   = origin.value.custom_origin_config.origin_ssl_protocols
      }

      s3_origin_config {
        origin_access_identity = origin.value.s3_origin_config.origin_access_identity
      }
    }
  }

  # Default cache behavior
  default_cache_behavior {
    target_origin_id       = each.value.default_cache_behavior.target_origin_id
    viewer_protocol_policy = each.value.default_cache_behavior.viewer_protocol_policy
    allowed_methods        = each.value.default_cache_behavior.allowed_methods
    cached_methods         = each.value.default_cache_behavior.cached_methods
    compress               = each.value.default_cache_behavior.compress

    forwarded_values {
      query_string = each.value.default_cache_behavior.forwarded_values.query_string
      cookies {
        forward = each.value.default_cache_behavior.forwarded_values.cookies.forward
      }
    }
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = each.value.geo_restriction.restriction_type
      locations        = each.value.geo_restriction.locations
    }
  }

  # Viewer certificate
  viewer_certificate {
    cloudfront_default_certificate = each.value.viewer_certificate.cloudfront_default_certificate
    acm_certificate_arn            = each.value.viewer_certificate.acm_certificate_arn
    ssl_support_method             = each.value.viewer_certificate.ssl_support_method
    minimum_protocol_version       = each.value.viewer_certificate.minimum_protocol_version
  }

  # Aliases
  aliases = each.value.aliases

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "cloudfront-distribution"
    }
  )
}
