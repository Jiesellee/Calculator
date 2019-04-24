// Later on theres going to be a data resource for aws organisations. When that happens use that.
variable "aws_accounts" {
  type        = "list"
  description = "describe your variable"
  default     = []
}

variable "s3_bucket_name" {
  type        = "string"
  description = "the bucket to push logs to in the monitoring account"
  default     = "ri-monitoring-cloudtrail"
}
