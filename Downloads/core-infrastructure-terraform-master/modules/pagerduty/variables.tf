// variable

variable "environment" {
  type        = "string"
  description = "the logical environment where this code will run in"
}

variable "project_name" {
  type        = "string"
  description = "the project/product name"
}

variable "team_ooh_list" {
  type        = "list"
  description = "Outside office hours team that will be created in pagerduty for this product/project."
}

variable "team_doh_list" {
  type        = "list"
  description = "During office hours team that will be created in pagerduty for this product/project."
}

// schedule

variable "sched_rot_interval" {
  type        = "string"
  description = "Time length in seconds for the amount of time a scheduled rotation for an on-call team should last"
}

variable "sched_rot_start" {
  type        = "string"
  description = "The date and time when the rotation starts"
}

variable "users_ids" {
  type        = "list"
  description = "List of user ids to be added to the outside office hours schedule"
}

// services

variable "services" {
  type        = "map"
  description = "Project/product services map[string]string. The format for the comma separated map values is **service_name, auto_resolve_timeout,acknowledgment_timeout,escalation_policy**"
}

variable "service_lookup" {
  type        = "map"
  description = "Project/product service lookup map used for outputs."
}
