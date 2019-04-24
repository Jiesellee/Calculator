variable "users" {
  type        = "list"
  description = "Users to create in the account, dont forget to create a pgp entry too!"
  default     = []
}

// you must provide on of these!
variable "users_pgp_keys" {
  type        = "map"
  description = "map of users pgp public keys. YOU MUST PROVIDE ONE!"
  default     = {}
}

variable "administrators" {
  type        = "list"
  description = "administrator users"
  default     = []
}

variable "developers" {
  type        = "list"
  description = "developer users"
  default     = []
}

variable "aws_accounts" {
  type        = "map"
  description = "list of environment aws accounts"
  default     = {}
}

variable "developer_account_access" {
  type        = "list"
  description = "list of accounts developers get R/O access to"
  default     = []
}

variable "administrator_account_access" {
  type        = "list"
  description = "list of accounts developers get R/W access to"
  default     = []
}
