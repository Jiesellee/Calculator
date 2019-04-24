resource "aws_cloudwatch_metric_alarm" "ecs_cpu_utilisation" {
  alarm_name          = "${var.project_name}-${var.service_name}-${var.environment}-ecs-cpu-utilisation"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.min_evaluation_period}"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.min_period_secs}"
  statistic           = "Average"
  threshold           = "80"
  treat_missing_data  = "breaching"
  alarm_actions       = ["${var.sns_major_topic_arn}"]
  alarm_description   = "${var.service_name} has gone above threshold for cpu utilisation"

  dimensions {
    ClusterName = "${var.cluster_name}"
    ServiceName = "${var.service_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_utilisation" {
  alarm_name          = "${var.project_name}-${var.service_name}-${var.environment}-ecs-memory-utilisation"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.min_evaluation_period}"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "${var.min_period_secs}"
  statistic           = "Average"
  threshold           = "80"
  treat_missing_data  = "breaching"
  alarm_actions       = ["${var.sns_major_topic_arn}"]
  alarm_description   = "${var.service_name} has gone above threshold for memory utilisation"

  dimensions {
    ClusterName = "${var.cluster_name}"
    ServiceName = "${var.service_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "ecs_insufficient_tasks" {
  alarm_name          = "${var.project_name}-${var.service_name}-${var.environment}-ecs-insufficient-tasks"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "${var.min_evaluation_period}"

  // yeah thats a weird metric name, but this actually equals the amount of tasks running.
  metric_name        = "CPUUtilization"
  namespace          = "AWS/ECS"
  period             = "${var.min_period_secs}"
  statistic          = "SampleCount"
  threshold          = "${var.min_service_tasks}"
  treat_missing_data = "breaching"
  alarm_description  = "${var.service_name} has gone below the threshold for tasks running"
  alarm_actions      = ["${var.sns_major_topic_arn}"]

  dimensions {
    ClusterName = "${var.cluster_name}"
    ServiceName = "${var.service_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "application_error_alarm" {
  alarm_name          = "${var.project_name}-${var.service_name}-${var.environment}-application-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "${var.project_name}-${var.service_name}-error-count"
  namespace           = "CustomLogs"
  period              = "120"
  statistic           = "Sum"
  threshold           = "${var.min_service_threshold}"
  alarm_description   = "${var.service_name} has gone above threshold for application errors"
  treat_missing_data  = "notBreaching"
  alarm_actions       = ["${var.sns_minor_topic_arn}"]
  count               = "${var.enable_log_filtering ? 1 : 0}"
}

resource "aws_cloudwatch_log_metric_filter" "application_error_log_filter" {
  name           = "${var.project_name}-${var.service_name}-${var.environment}-application-error-log-filter"
  pattern        = "${var.pattern_error}"
  log_group_name = "${var.log_group_name}"
  count          = "${var.enable_log_filtering ? 1 : 0}"

  metric_transformation {
    name      = "${var.project_name}-${var.service_name}-error-count"
    namespace = "CustomLogs"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "application_fatal_alarm" {
  alarm_name          = "${var.project_name}-${var.service_name}-${var.environment}-application-fatal-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "${var.project_name}-${var.service_name}-fatal-count"
  namespace           = "CustomLogs"
  period              = "${var.min_period_secs}"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "${var.service_name} has gone above threshold for application fatals"
  treat_missing_data  = "notBreaching"
  alarm_actions       = ["${var.sns_major_topic_arn}"]
  count               = "${var.enable_log_filtering ? 1 : 0}"
}

resource "aws_cloudwatch_log_metric_filter" "application_fatal_log_filter" {
  name           = "${var.project_name}-${var.service_name}-${var.environment}-application-fatal-log-filter"
  pattern        = "${var.pattern_fatal}"
  log_group_name = "${var.log_group_name}"
  count          = "${var.enable_log_filtering ? 1 : 0}"

  metric_transformation {
    name      = "${var.project_name}-${var.service_name}-fatal-count"
    namespace = "CustomLogs"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "application_panic_alarm" {
  alarm_name          = "${var.project_name}-${var.service_name}-${var.environment}-application-panic-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "${var.project_name}-${var.service_name}-panic-count"
  namespace           = "CustomLogs"
  period              = "${var.min_period_secs}"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "${var.service_name} has gone above threshold for application panics"
  treat_missing_data  = "notBreaching"
  alarm_actions       = ["${var.sns_major_topic_arn}"]
  count               = "${var.enable_log_filtering ? 1 : 0}"
}

resource "aws_cloudwatch_log_metric_filter" "application_panic_log_filter" {
  name           = "${var.project_name}-${var.service_name}-${var.environment}-application-panic-log-filter"
  pattern        = "${var.pattern_panic}"
  log_group_name = "${var.log_group_name}"
  count          = "${var.enable_log_filtering ? 1 : 0}"

  metric_transformation {
    name      = "${var.project_name}-${var.service_name}-panic-count"
    namespace = "CustomLogs"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_error_rates_500" {
  alarm_name          = "${var.project_name}-${var.service_name}-${var.environment}-alb-error-rates-500"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "${var.min_period_secs}"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
  alarm_actions       = ["${var.sns_minor_topic_arn}"]
  alarm_description   = "${var.service_name} has returned a 500 on the alb"

  dimensions {
    LoadBalancer = "${var.aws_alb_arn_suffix}"
    TargetGroup  = "${var.ecs_service_alb_target_group_arn_suffix}"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_error_rates_400" {
  alarm_name          = "${var.project_name}-${var.service_name}-${var.environment}-alb-error-rates-400"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "${var.min_period_secs}"
  statistic           = "Sum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
  alarm_actions       = ["${var.sns_minor_topic_arn}"]
  alarm_description   = "${var.service_name} has returned a 400 on the alb"
  count               = "${var.enable_elb_400_alarms ? 1 : 0}"

  dimensions {
    LoadBalancer = "${var.aws_alb_arn_suffix}"
    TargetGroup  = "${var.ecs_service_alb_target_group_arn_suffix}"
  }
}

resource "aws_cloudwatch_metric_alarm" "healthy_servers_elb_alarm" {
  alarm_name          = "${var.project_name}-${var.service_name}-${var.environment}-healthy-servers-elb"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "${var.min_evaluation_period}"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "${var.min_period_secs}"
  statistic           = "Average"
  threshold           = "${var.min_service_threshold}"
  alarm_description   = "${var.service_name} has gone below threshold for healthy servers on the elb"
  treat_missing_data  = "breaching"
  alarm_actions       = ["${var.sns_major_topic_arn}"]

  dimensions {
    LoadBalancer = "${var.aws_alb_arn_suffix}"
    TargetGroup  = "${var.ecs_service_alb_target_group_arn_suffix}"
  }
}
