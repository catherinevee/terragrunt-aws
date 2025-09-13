# CloudWatch Module - Outputs

# Log Groups
output "log_groups" {
  description = "Map of CloudWatch log groups"
  value       = module.cloudwatch.log_groups
}

output "log_group_arns" {
  description = "Map of CloudWatch log group ARNs"
  value       = module.cloudwatch.log_group_arns
}

output "log_group_names" {
  description = "Map of CloudWatch log group names"
  value       = module.cloudwatch.log_group_names
}

# Log Streams
output "log_streams" {
  description = "Map of CloudWatch log streams"
  value       = module.cloudwatch.log_streams
}

output "log_stream_arns" {
  description = "Map of CloudWatch log stream ARNs"
  value       = module.cloudwatch.log_stream_arns
}

# Log Metric Filters
output "log_metric_filters" {
  description = "Map of CloudWatch log metric filters"
  value       = module.cloudwatch.log_metric_filters
}

output "log_metric_filter_arns" {
  description = "Map of CloudWatch log metric filter ARNs"
  value       = module.cloudwatch.log_metric_filter_arns
}

# Log Subscriptions
output "log_subscriptions" {
  description = "Map of CloudWatch log subscriptions"
  value       = module.cloudwatch.log_subscriptions
}

output "log_subscription_arns" {
  description = "Map of CloudWatch log subscription ARNs"
  value       = module.cloudwatch.log_subscription_arns
}

# Dashboards
output "dashboards" {
  description = "Map of CloudWatch dashboards"
  value       = module.cloudwatch.dashboards
}

output "dashboard_arns" {
  description = "Map of CloudWatch dashboard ARNs"
  value       = module.cloudwatch.dashboard_arns
}

# Alarms
output "alarms" {
  description = "Map of CloudWatch alarms"
  value       = module.cloudwatch.alarms
}

output "alarm_arns" {
  description = "Map of CloudWatch alarm ARNs"
  value       = module.cloudwatch.alarm_arns
}

# Composite Alarms
output "composite_alarms" {
  description = "Map of CloudWatch composite alarms"
  value       = module.cloudwatch.composite_alarms
}

output "composite_alarm_arns" {
  description = "Map of CloudWatch composite alarm ARNs"
  value       = module.cloudwatch.composite_alarm_arns
}

# Anomaly Detectors
output "anomaly_detectors" {
  description = "Map of CloudWatch anomaly detectors"
  value       = module.cloudwatch.anomaly_detectors
}

output "anomaly_detector_arns" {
  description = "Map of CloudWatch anomaly detector ARNs"
  value       = module.cloudwatch.anomaly_detector_arns
}

# Insights Queries
output "insights_queries" {
  description = "Map of CloudWatch Insights queries"
  value       = module.cloudwatch.insights_queries
}

output "insights_query_arns" {
  description = "Map of CloudWatch Insights query ARNs"
  value       = module.cloudwatch.insights_query_arns
}

# Contributor Insights
output "contributor_insights" {
  description = "Map of CloudWatch Contributor Insights"
  value       = module.cloudwatch.contributor_insights
}

output "contributor_insights_arns" {
  description = "Map of CloudWatch Contributor Insights ARNs"
  value       = module.cloudwatch.contributor_insights_arns
}

# Metric Streams
output "metric_streams" {
  description = "Map of CloudWatch metric streams"
  value       = module.cloudwatch.metric_streams
}

output "metric_stream_arns" {
  description = "Map of CloudWatch metric stream ARNs"
  value       = module.cloudwatch.metric_stream_arns
}

# Synthetics
output "synthetics" {
  description = "Map of CloudWatch Synthetics canaries"
  value       = module.cloudwatch.synthetics
}

output "synthetics_arns" {
  description = "Map of CloudWatch Synthetics canary ARNs"
  value       = module.cloudwatch.synthetics_arns
}

# RUM App Monitors
output "rum_app_monitors" {
  description = "Map of CloudWatch RUM app monitors"
  value       = module.cloudwatch.rum_app_monitors
}

output "rum_app_monitor_arns" {
  description = "Map of CloudWatch RUM app monitor ARNs"
  value       = module.cloudwatch.rum_app_monitor_arns
}

# Additional Resources
output "additional_log_groups" {
  description = "Map of additional CloudWatch log groups"
  value       = aws_cloudwatch_log_group.additional
}

output "additional_log_group_arns" {
  description = "Map of additional CloudWatch log group ARNs"
  value       = { for k, v in aws_cloudwatch_log_group.additional : k => v.arn }
}

output "additional_log_streams" {
  description = "Map of additional CloudWatch log streams"
  value       = aws_cloudwatch_log_stream.additional
}

output "additional_log_stream_arns" {
  description = "Map of additional CloudWatch log stream ARNs"
  value       = { for k, v in aws_cloudwatch_log_stream.additional : k => v.arn }
}

output "additional_log_metric_filters" {
  description = "Map of additional CloudWatch log metric filters"
  value       = aws_cloudwatch_log_metric_filter.additional
}

output "additional_log_metric_filter_arns" {
  description = "Map of additional CloudWatch log metric filter ARNs"
  value       = { for k, v in aws_cloudwatch_log_metric_filter.additional : k => v.arn }
}

output "additional_dashboards" {
  description = "Map of additional CloudWatch dashboards"
  value       = aws_cloudwatch_dashboard.additional
}

output "additional_dashboard_arns" {
  description = "Map of additional CloudWatch dashboard ARNs"
  value       = { for k, v in aws_cloudwatch_dashboard.additional : k => v.arn }
}

output "additional_alarms" {
  description = "Map of additional CloudWatch alarms"
  value       = aws_cloudwatch_metric_alarm.additional
}

output "additional_alarm_arns" {
  description = "Map of additional CloudWatch alarm ARNs"
  value       = { for k, v in aws_cloudwatch_metric_alarm.additional : k => v.arn }
}

output "additional_composite_alarms" {
  description = "Map of additional CloudWatch composite alarms"
  value       = aws_cloudwatch_composite_alarm.additional
}

output "additional_composite_alarm_arns" {
  description = "Map of additional CloudWatch composite alarm ARNs"
  value       = { for k, v in aws_cloudwatch_composite_alarm.additional : k => v.arn }
}

output "additional_anomaly_detectors" {
  description = "Map of additional CloudWatch anomaly detectors"
  value       = aws_cloudwatch_anomaly_detector.additional
}

output "additional_anomaly_detector_arns" {
  description = "Map of additional CloudWatch anomaly detector ARNs"
  value       = { for k, v in aws_cloudwatch_anomaly_detector.additional : k => v.arn }
}

output "additional_insights_queries" {
  description = "Map of additional CloudWatch Insights queries"
  value       = aws_cloudwatch_insights_query.additional
}

output "additional_insights_query_arns" {
  description = "Map of additional CloudWatch Insights query ARNs"
  value       = { for k, v in aws_cloudwatch_insights_query.additional : k => v.arn }
}

output "additional_contributor_insights" {
  description = "Map of additional CloudWatch Contributor Insights"
  value       = aws_cloudwatch_contributor_insights_rule.additional
}

output "additional_contributor_insights_arns" {
  description = "Map of additional CloudWatch Contributor Insights ARNs"
  value       = { for k, v in aws_cloudwatch_contributor_insights_rule.additional : k => v.arn }
}

output "additional_metric_streams" {
  description = "Map of additional CloudWatch metric streams"
  value       = aws_cloudwatch_metric_stream.additional
}

output "additional_metric_stream_arns" {
  description = "Map of additional CloudWatch metric stream ARNs"
  value       = { for k, v in aws_cloudwatch_metric_stream.additional : k => v.arn }
}

output "additional_synthetics" {
  description = "Map of additional CloudWatch Synthetics canaries"
  value       = aws_synthetics_canary.additional
}

output "additional_synthetics_arns" {
  description = "Map of additional CloudWatch Synthetics canary ARNs"
  value       = { for k, v in aws_synthetics_canary.additional : k => v.arn }
}

output "additional_rum_app_monitors" {
  description = "Map of additional CloudWatch RUM app monitors"
  value       = aws_rum_app_monitor.additional
}

output "additional_rum_app_monitor_arns" {
  description = "Map of additional CloudWatch RUM app monitor ARNs"
  value       = { for k, v in aws_rum_app_monitor.additional : k => v.arn }
}
