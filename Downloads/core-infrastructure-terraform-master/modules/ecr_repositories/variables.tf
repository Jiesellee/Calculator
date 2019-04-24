variable "repository_names" {
  type        = "list"
  description = "names of repositories to create"
  default     = []
}

variable "allowed_account_ids" {
  type        = "list"
  description = "ids of AWS accounts which can pull images from the repositories."
  default     = []
}
