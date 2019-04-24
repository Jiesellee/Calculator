variable "aws_account_ids" {
  type        = "map"
  description = "AWS account IDs that users should be allowed access to"
}

variable "administrator_group_membership" {
  type        = "list"
  description = "list of users member of the administrator group"
  default     = []
}

variable "developer_group_membership" {
  type        = "list"
  description = "list of users member of the developer group"
  default     = []
}

variable "operations_group_membership" {
  type        = "list"
  description = "list of users member of the operations group"
  default     = []
}

variable "project_name" {
  type        = "string"
  description = "name of the project"
}
