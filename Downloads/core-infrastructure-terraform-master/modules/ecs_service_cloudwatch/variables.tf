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

variable "cluster_name" {
  type        = "string"
  description = "name of the ECS cluster"
}

variable "service_name" {
  type        = "string"
  description = "name of the ECS service"
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

variable "log_group_name" {
  type        = "string"
  description = "log group name where filter is applied"
  default     = ""
}

variable "min_service_tasks" {
  default     = 2
  description = "The minimum number of ecs tasks deployed for this service"
}

variable "ecs_service_alb_target_group_arn_suffix" {
  type        = "string"
  description = "ecs service alb target group arn suffix"
}

variable "aws_alb_arn_suffix" {
  type        = "string"
  description = "alb arn suffix"
}

variable "pattern_error" {
  default     = "{ ($.level = \"error\" ) }"
  description = "Pattern for error matching"
}

variable "pattern_fatal" {
  default     = "{ ($.level = \"fatal\" ) }"
  description = "Pattern for fatal matching"
}

variable "pattern_panic" {
  default     = "{ ($.level = \"panic\" ) }"
  description = "Pattern for panic matching"
}

variable "enable_log_filtering" {
  default     = true
  description = "Enables log parsing and alarming"
}

variable "enable_elb_400_alarms" {
  default     = true
  description = "Enables alarming on returned 400 from the elb"
}
