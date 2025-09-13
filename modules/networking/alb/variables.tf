# Application Load Balancer Module - Variables

variable "environment" {
  description = "The environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where to create the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the ALB will be deployed"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the ALB"
  type        = list(string)
}

variable "enable_access_logs" {
  description = "Whether to enable access logs"
  type        = bool
  default     = false
}

variable "access_logs_bucket" {
  description = "S3 bucket for access logs"
  type        = string
  default     = null
}

variable "access_logs_prefix" {
  description = "S3 prefix for access logs"
  type        = string
  default     = "alb"
}

variable "target_groups" {
  description = "List of target groups"
  type = list(object({
    name             = string
    backend_protocol = string
    backend_port     = number
    target_type      = string
    health_check = object({
      enabled             = bool
      interval            = number
      path                = string
      port                = string
      protocol            = string
      timeout             = number
      healthy_threshold   = number
      unhealthy_threshold = number
      matcher             = string
    })
    targets = list(object({
      target_id = string
      port      = number
    }))
  }))
  default = []
}

variable "http_tcp_listeners" {
  description = "List of HTTP/TCP listeners"
  type = list(object({
    port               = number
    protocol           = string
    target_group_index = number
  }))
  default = []
}

variable "https_listeners" {
  description = "List of HTTPS listeners"
  type = list(object({
    port               = number
    protocol           = string
    certificate_arn    = string
    target_group_index = number
  }))
  default = []
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
  default     = null
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "Idle timeout in seconds"
  type        = number
  default     = 60
}

variable "connection_draining_timeout" {
  description = "Connection draining timeout in seconds"
  type        = number
  default     = 300
}

variable "health_check_grace_period_seconds" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 300
}

variable "additional_listener_rules" {
  description = "Map of additional listener rules"
  type = map(object({
    priority         = number
    action_type      = string
    target_group_arn = string
    condition_field  = string
    condition_values = list(string)
  }))
  default = {}
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
