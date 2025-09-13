# Network Load Balancer Module - Using official AWS NLB module from Terraform Registry

module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "${var.environment}-${var.name}"

  load_balancer_type = "network"

  vpc_id          = var.vpc_id
  subnets         = var.subnet_ids
  security_groups = var.security_group_ids

  # Access logs
  access_logs = var.enable_access_logs ? {
    bucket  = var.access_logs_bucket
    prefix  = var.access_logs_prefix
    enabled = true
  } : null

  # Target groups
  target_groups = var.target_groups

  # Listeners
  http_tcp_listeners = var.http_tcp_listeners
  https_listeners    = var.https_listeners

  # SSL configuration
  certificate_arn = var.certificate_arn

  # Tags
  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}"
      Type = "network-load-balancer"
    }
  )

  # Enable deletion protection
  enable_deletion_protection = var.enable_deletion_protection

  # Enable cross-zone load balancing
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  # Idle timeout
  idle_timeout = var.idle_timeout

  # Connection draining
  connection_draining_timeout = var.connection_draining_timeout

  # Health check configuration
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
}

# Additional NLB resources if needed
resource "aws_lb_listener_rule" "additional_rules" {
  for_each = var.additional_listener_rules

  listener_arn = module.nlb.arn
  priority     = each.value.priority

  action {
    type             = each.value.action_type
    target_group_arn = each.value.target_group_arn
  }

  condition {
    field  = each.value.condition_field
    values = each.value.condition_values
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.name}-rule-${each.key}"
    }
  )
}
