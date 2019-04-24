variable "project_name" {
  type        = "string"
  description = "describe your variable"
}

variable "environment" {
  type        = "string"
  description = "describe your variable"
}

variable "vpc_id" {
  type        = "string"
  description = "describe your variable"
}

variable "private_subnets" {
  type        = "list"
  description = "describe your variable"
}

variable "security_group" {
  type        = "string"
  description = "describe your variable"
}

variable "kms_key_alias_arn" {
  type        = "string"
  description = "arn of the kms key used to encrypt the slack webhook url"
}

variable "sns_to_slack_channel_mapping" {
  type        = "map"
  description = "the lambda function sns topic to slack channel mapping"
}

variable "encrypted_slack_webhook_url" {
  type        = "string"
  description = "kms encrypted slack webhook url"
}

variable "slack_lambda_zip_shasum" {
  type        = "string"
  description = "shasum of the file in s3"
  default     = ""
}
