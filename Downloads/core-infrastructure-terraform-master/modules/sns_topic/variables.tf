variable "project_name" {
  type        = "string"
  description = "describe your variable"
}

variable "environment" {
  type        = "string"
  description = "describe your variable"
}

variable "sns_topic_names" {
  type        = "list"
  description = "A list of SNS topics"
}
