// using differently named variable to distinguish between test and real pagerduty tokens
variable "pagerduty_tf_token_ci_test" {
  type        = "string"
  description = "the pagerduty full access API token"
  default     = "none"
}

variable "environment" {
  type        = "string"
  description = "the environment of the account"
  default     = "ci"
}

variable "project_name" {
  type        = "string"
  description = "the name of the project"
  default     = "payment"
}

variable "team_ooh" {
  type        = "string"
  description = "Outside office hours team that will be created in pagerduty for this product/project."

  default = "outside_office_hours"
}

variable "team_doh" {
  type        = "string"
  description = "During office hours team that will be created in pagerduty for this product/project."

  default = "during_office_hours"
}

// user details

variable "users" {
  type        = "map"
  description = "Map of user names. Each user is assigned an index to ensure the same order is kept and terraform doesn't re-create users that it has already created."

  default = {
    "0" = "zeus"
    "1" = "apollo"
    "2" = "hera"
    "3" = "poseidon"
  }
}

variable "user_emails" {
  type        = "map"
  description = "Map of user emails. **Each user is assigned an index to stop terraform from reordering resources. The order of the indexes must match the order of the user_names indexes**"

  default = {
    "0" = "zeus@nodomain.noexist"
    "1" = "apollo@nodomain.noexist"
    "2" = "hera@nodomain.noexist"
    "3" = "poseidon@nodomain.noexist"
  }
}

variable "user_pg_roles" {
  type        = "map"
  description = "Map of pagerduty user roles. **Each user is assigned an index to stop terraform from reordering resources. The order of the indexes must match the order of the user_names indexes**"

  default = {
    "0" = "admin"
    "1" = "user"
    "2" = "user"
    "3" = "user"
  }
}

// end user details

// schedule
variable "sched_rot_interval" {
  type        = "string"
  description = "Time lenght in seconds for the amount of time a scheduled rotation for an on-call team should last"
  default     = "604800"
}

variable "sched_rot_start" {
  type        = "string"
  description = "The date and time when the rotation starts"
  default     = "2017-10-01T20:00:00-05:00"
}

/* services */

variable "service_lookup" {
  type        = "map"
  description = "Project/product service lookup map used for outputs."

  default = {
    "0" = "service01"
    "1" = "service02"
  }
}

variable "services" {
  type        = "map"
  description = "Project/product services"

  //format = "service_name, auto_resolve_timeout,acknowledgment_timeout,escalation_policy"
  default = {
    "0" = "service01,259200,300,ooh"
    "1" = "service02,259200,600,doh"
  }
}
