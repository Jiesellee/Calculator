variable "project_name" {
  type        = "string"
  description = "describe your variable"

  default = "test1234adsf"
}

variable "environment" {
  type        = "string"
  description = "describe your variable"

  default = "test"
}

variable "sns_topic_names" {
  type        = "list"
  description = "A list of SNS topics"

  default = ["foo", "bar"]
}
