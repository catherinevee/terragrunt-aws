# CloudWatch Module - Using official AWS CloudWatch module from Terraform Registry

module "cloudwatch" {
  source  = "terraform-aws-modules/cloudwatch/aws"
  version = "~> 3.0"

  # CloudWatch Log Groups
  log_groups = var.log_groups

  # CloudWatch Log Streams
  log_streams = var.log_streams

  # CloudWatch Log Metric Filters
  log_metric_filters = var.log_metric_filters

  # CloudWatch Log Subscriptions
  log_subscriptions = var.log_subscriptions

  # CloudWatch Dashboards
  dashboards = var.dashboards

  # CloudWatch Alarms
  alarms = var.alarms

  # CloudWatch Composite Alarms
  composite_alarms = var.composite_alarms

  # CloudWatch Anomaly Detectors
  anomaly_detectors = var.anomaly_detectors

  # CloudWatch Insights Queries
  insights_queries = var.insights_queries

  # CloudWatch Contributor Insights
  contributor_insights = var.contributor_insights

  # CloudWatch Metric Streams
  metric_streams = var.metric_streams

  # CloudWatch Synthetics
  synthetics = var.synthetics

  # CloudWatch RUM
  rum_app_monitors = var.rum_app_monitors

  # Tags
  tags = merge(
    var.common_tags,
    {
      Type = "cloudwatch"
    }
  )
}

# Additional CloudWatch resources
resource "aws_cloudwatch_log_group" "additional" {
  for_each = var.additional_log_groups

  name              = each.key
  retention_in_days = each.value.retention_in_days
  kms_key_id        = each.value.kms_key_id

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "cloudwatch-log-group"
    }
  )
}

resource "aws_cloudwatch_log_stream" "additional" {
  for_each = var.additional_log_streams

  name           = each.key
  log_group_name = each.value.log_group_name
}

resource "aws_cloudwatch_log_metric_filter" "additional" {
  for_each = var.additional_log_metric_filters

  name           = each.key
  log_group_name = each.value.log_group_name
  pattern        = each.value.pattern

  metric_transformation {
    name      = each.value.metric_name
    namespace = each.value.metric_namespace
    value     = each.value.metric_value
  }
}

resource "aws_cloudwatch_dashboard" "additional" {
  for_each = var.additional_dashboards

  dashboard_name = each.key
  dashboard_body = each.value.dashboard_body
}

resource "aws_cloudwatch_metric_alarm" "additional" {
  for_each = var.additional_alarms

  alarm_name          = each.key
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = each.value.alarm_description
  alarm_actions       = each.value.alarm_actions
  ok_actions          = each.value.ok_actions
  insufficient_data_actions = each.value.insufficient_data_actions

  dimensions = each.value.dimensions

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "cloudwatch-alarm"
    }
  )
}

resource "aws_cloudwatch_composite_alarm" "additional" {
  for_each = var.additional_composite_alarms

  alarm_name = each.key
  alarm_description = each.value.alarm_description
  alarm_rule = each.value.alarm_rule
  alarm_actions = each.value.alarm_actions
  ok_actions = each.value.ok_actions
  insufficient_data_actions = each.value.insufficient_data_actions

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "cloudwatch-composite-alarm"
    }
  )
}

resource "aws_cloudwatch_anomaly_detector" "additional" {
  for_each = var.additional_anomaly_detectors

  name = each.key
  namespace = each.value.namespace
  metric_name = each.value.metric_name
  stat = each.value.stat

  configuration = each.value.configuration

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "cloudwatch-anomaly-detector"
    }
  )
}

resource "aws_cloudwatch_insights_query" "additional" {
  for_each = var.additional_insights_queries

  log_group_name = each.value.log_group_name
  query_string = each.value.query_string
  start_time = each.value.start_time
  end_time = each.value.end_time
}

resource "aws_cloudwatch_contributor_insights_rule" "additional" {
  for_each = var.additional_contributor_insights

  name = each.key
  rule_definition = each.value.rule_definition
  state = each.value.state
}

resource "aws_cloudwatch_metric_stream" "additional" {
  for_each = var.additional_metric_streams

  name = each.key
  role_arn = each.value.role_arn
  firehose_arn = each.value.firehose_arn
  output_format = each.value.output_format

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "cloudwatch-metric-stream"
    }
  )
}

resource "aws_synthetics_canary" "additional" {
  for_each = var.additional_synthetics

  name = each.key
  artifact_s3_location = each.value.artifact_s3_location
  execution_role_arn = each.value.execution_role_arn
  handler = each.value.handler
  runtime_version = each.value.runtime_version
  schedule = each.value.schedule

  run_config = each.value.run_config

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "synthetics-canary"
    }
  )
}

resource "aws_rum_app_monitor" "additional" {
  for_each = var.additional_rum_app_monitors

  name = each.key
  domain = each.value.domain

  app_monitor_configuration = each.value.app_monitor_configuration

  tags = merge(
    var.common_tags,
    {
      Name = each.key
      Type = "rum-app-monitor"
    }
  )
}
