output "sns_slack_topic_arn" {
  value = "${aws_sns_topic.alerts.arn}"
}