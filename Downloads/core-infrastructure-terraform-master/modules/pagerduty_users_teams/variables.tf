variable "project_name" {
  type        = "string"
  description = "name of project"
}

variable "environment" {
  type        = "string"
  description = "the environment in which terraform is running e.g. ci"
}

// team details

variable "team_ooh" {
  type        = "string"
  description = "Outside office hours team that will be created in pagerduty for this product/project."
}

variable "team_doh" {
  type        = "string"
  description = "During office hours team that will be created in pagerduty for this product/project."
}

// user details

variable "users" {
  type        = "map"
  description = "Map of user names. **Can only be instantiated once per project, don't use per environment**.  Each user is assigned an index to ensure the same order is kept and terraform doesn't re-create users that it has already created. "
}

variable "user_emails" {
  type        = "map"
  description = "Map of user emails. **Each user is assigned an index to stop terraform from reordering resources. The order of the indexes must match the order of the user_names indexes**"
}

variable "user_pg_roles" {
  type        = "map"
  description = "Map of pagerduty user roles. **Each user is assigned an index to stop terraform from reordering resources. The order of the indexes must match the order of the user_names indexes**"
}
