variable "min_period_secs" {
  type        = "string"
  description = "Min interval period"
  default     = "60"
}

variable "min_evaluation_period" {
  type    = "string"
  default = "2"
}

variable "min_service_threshold" {
  type        = "string"
  description = "describe your variable"
  default     = "1"
}

variable "environment" {
  type = "string"
}

variable "project_name" {
  type        = "string"
  description = "name of the project"
}

variable "sns_minor_topic_arn" {
  type        = "string"
  description = "sns topic to send minor cloudwatch events to"
}

variable "sns_major_topic_arn" {
  type        = "string"
  description = "sns topic to send major cloudwatch events to"
}

variable "aws_asg_name" {
  type        = "string"
  description = "alb asg name"
}
