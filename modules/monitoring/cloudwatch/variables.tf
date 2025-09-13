# CloudWatch Module - Variables

variable "log_groups" {
  description = "Map of CloudWatch log groups to create"
  type = map(object({
    name              = string
    retention_in_days = number
    kms_key_id        = string
    tags = map(string)
  }))
  default = {}
}

variable "log_streams" {
  description = "Map of CloudWatch log streams to create"
  type = map(object({
    name           = string
    log_group_name = string
  }))
  default = {}
}

variable "log_metric_filters" {
  description = "Map of CloudWatch log metric filters to create"
  type = map(object({
    name           = string
    log_group_name = string
    pattern        = string
    metric_name    = string
    metric_namespace = string
    metric_value   = string
  }))
  default = {}
}

variable "log_subscriptions" {
  description = "Map of CloudWatch log subscriptions to create"
  type = map(object({
    name           = string
    log_group_name = string
    destination_arn = string
    filter_pattern = string
    role_arn       = string
  }))
  default = {}
}

variable "dashboards" {
  description = "Map of CloudWatch dashboards to create"
  type = map(object({
    dashboard_name = string
    dashboard_body = string
  }))
  default = {}
}

variable "alarms" {
  description = "Map of CloudWatch alarms to create"
  type = map(object({
    alarm_name          = string
    comparison_operator = string
    evaluation_periods  = number
    metric_name         = string
    namespace           = string
    period              = number
    statistic           = string
    threshold           = number
    alarm_description   = string
    alarm_actions       = list(string)
    ok_actions          = list(string)
    insufficient_data_actions = list(string)
    dimensions = map(string)
  }))
  default = {}
}

variable "composite_alarms" {
  description = "Map of CloudWatch composite alarms to create"
  type = map(object({
    alarm_name = string
    alarm_description = string
    alarm_rule = string
    alarm_actions = list(string)
    ok_actions = list(string)
    insufficient_data_actions = list(string)
  }))
  default = {}
}

variable "anomaly_detectors" {
  description = "Map of CloudWatch anomaly detectors to create"
  type = map(object({
    name = string
    namespace = string
    metric_name = string
    stat = string
    configuration = object({
      excluded_time_ranges = list(object({
        start_time = string
        end_time = string
      }))
      metric_math_anomaly_detector = object({
        metric_data_queries = list(object({
          id = string
          expression = string
          metric_stat = object({
            metric = object({
              metric_name = string
              namespace = string
              dimensions = map(string)
            })
            period = number
            stat = string
          })
          return_data = bool
        }))
      })
    })
  }))
  default = {}
}

variable "insights_queries" {
  description = "Map of CloudWatch Insights queries to create"
  type = map(object({
    log_group_name = string
    query_string = string
    start_time = string
    end_time = string
  }))
  default = {}
}

variable "contributor_insights" {
  description = "Map of CloudWatch Contributor Insights to create"
  type = map(object({
    name = string
    rule_definition = string
    state = string
  }))
  default = {}
}

variable "metric_streams" {
  description = "Map of CloudWatch metric streams to create"
  type = map(object({
    name = string
    role_arn = string
    firehose_arn = string
    output_format = string
  }))
  default = {}
}

variable "synthetics" {
  description = "Map of CloudWatch Synthetics canaries to create"
  type = map(object({
    name = string
    artifact_s3_location = string
    execution_role_arn = string
    handler = string
    runtime_version = string
    schedule = string
    run_config = object({
      active_tracing = bool
      environment_variables = map(string)
      memory_in_mb = number
      timeout_in_seconds = number
    })
  }))
  default = {}
}

variable "rum_app_monitors" {
  description = "Map of CloudWatch RUM app monitors to create"
  type = map(object({
    name = string
    domain = string
    app_monitor_configuration = object({
      allow_cookies = bool
      enable_xray = bool
      session_sample_rate = number
      telemetries = list(string)
    })
  }))
  default = {}
}

variable "additional_log_groups" {
  description = "Map of additional CloudWatch log groups to create"
  type = map(object({
    retention_in_days = number
    kms_key_id = string
  }))
  default = {}
}

variable "additional_log_streams" {
  description = "Map of additional CloudWatch log streams to create"
  type = map(object({
    log_group_name = string
  }))
  default = {}
}

variable "additional_log_metric_filters" {
  description = "Map of additional CloudWatch log metric filters to create"
  type = map(object({
    log_group_name = string
    pattern = string
    metric_name = string
    metric_namespace = string
    metric_value = string
  }))
  default = {}
}

variable "additional_dashboards" {
  description = "Map of additional CloudWatch dashboards to create"
  type = map(object({
    dashboard_body = string
  }))
  default = {}
}

variable "additional_alarms" {
  description = "Map of additional CloudWatch alarms to create"
  type = map(object({
    comparison_operator = string
    evaluation_periods = number
    metric_name = string
    namespace = string
    period = number
    statistic = string
    threshold = number
    alarm_description = string
    alarm_actions = list(string)
    ok_actions = list(string)
    insufficient_data_actions = list(string)
    dimensions = map(string)
  }))
  default = {}
}

variable "additional_composite_alarms" {
  description = "Map of additional CloudWatch composite alarms to create"
  type = map(object({
    alarm_description = string
    alarm_rule = string
    alarm_actions = list(string)
    ok_actions = list(string)
    insufficient_data_actions = list(string)
  }))
  default = {}
}

variable "additional_anomaly_detectors" {
  description = "Map of additional CloudWatch anomaly detectors to create"
  type = map(object({
    namespace = string
    metric_name = string
    stat = string
    configuration = object({
      excluded_time_ranges = list(object({
        start_time = string
        end_time = string
      }))
      metric_math_anomaly_detector = object({
        metric_data_queries = list(object({
          id = string
          expression = string
          metric_stat = object({
            metric = object({
              metric_name = string
              namespace = string
              dimensions = map(string)
            })
            period = number
            stat = string
          })
          return_data = bool
        }))
      })
    })
  }))
  default = {}
}

variable "additional_insights_queries" {
  description = "Map of additional CloudWatch Insights queries to create"
  type = map(object({
    log_group_name = string
    query_string = string
    start_time = string
    end_time = string
  }))
  default = {}
}

variable "additional_contributor_insights" {
  description = "Map of additional CloudWatch Contributor Insights to create"
  type = map(object({
    rule_definition = string
    state = string
  }))
  default = {}
}

variable "additional_metric_streams" {
  description = "Map of additional CloudWatch metric streams to create"
  type = map(object({
    role_arn = string
    firehose_arn = string
    output_format = string
  }))
  default = {}
}

variable "additional_synthetics" {
  description = "Map of additional CloudWatch Synthetics canaries to create"
  type = map(object({
    artifact_s3_location = string
    execution_role_arn = string
    handler = string
    runtime_version = string
    schedule = string
    run_config = object({
      active_tracing = bool
      environment_variables = map(string)
      memory_in_mb = number
      timeout_in_seconds = number
    })
  }))
  default = {}
}

variable "additional_rum_app_monitors" {
  description = "Map of additional CloudWatch RUM app monitors to create"
  type = map(object({
    domain = string
    app_monitor_configuration = object({
      allow_cookies = bool
      enable_xray = bool
      session_sample_rate = number
      telemetries = list(string)
    })
  }))
  default = {}
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
