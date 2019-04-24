output "sns_topic_arn" {
  value = "${zipmap(aws_sns_topic.alerts.*.id, aws_sns_topic.alerts.*.arn)}"
}
