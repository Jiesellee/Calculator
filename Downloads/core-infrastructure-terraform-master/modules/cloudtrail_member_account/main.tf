variable "s3_bucket_name" {
  type        = "string"
  description = "the bucket to push logs to in the monitoring account"
  default     = "ri-monitoring-cloudtrail"
}

resource "aws_cloudtrail" "default" {
  name                          = "trail-to-monitoring-account"
  s3_bucket_name                = "${var.s3_bucket_name}"
  include_global_service_events = false
}
