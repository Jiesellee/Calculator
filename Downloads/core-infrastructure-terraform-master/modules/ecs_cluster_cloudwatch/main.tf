resource "aws_cloudwatch_metric_alarm" "asg_cpu_utilisation" {
  alarm_name          = "${var.project_name}-${var.environment}-asg-cpu-utilisation"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "${var.min_evaluation_period}"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "${var.min_period_secs}"
  statistic           = "Average"
  threshold           = "80"
  treat_missing_data  = "breaching"
  alarm_actions       = ["${var.sns_major_topic_arn}"]
  alarm_description   = "This metric monitors cpu utilisation in asg"

  dimensions {
    AutoScalingGroupName = "${var.aws_asg_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "healthy_servers_asg_alarm" {
  alarm_name          = "${var.project_name}-${var.environment}-healthy-servers-asg"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "${var.min_evaluation_period}"
  metric_name         = "GroupInServiceInstances"
  namespace           = "AWS/AutoScaling"
  period              = "${var.min_period_secs}"
  statistic           = "Average"
  threshold           = "${var.min_service_threshold}"
  alarm_description   = "This metric monitors the healthy servers in the asg"
  treat_missing_data  = "breaching"
  alarm_actions       = ["${var.sns_major_topic_arn}"]

  dimensions {
    AutoScalingGroupName = "${var.aws_asg_name}"
  }
}
