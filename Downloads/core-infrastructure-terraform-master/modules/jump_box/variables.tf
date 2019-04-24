variable "project_name" {
  type        = "string"
  description = "name of the project"
}

variable "environment" {
  type        = "string"
  description = "environment the jump box is in"
}

variable "vpc_id" {
  type        = "string"
  description = "the id of your vpc"
}

variable "ssh_key_name" {
  type        = "string"
  description = "ssh keypair name for the jumpbox"
}

variable "subnet" {
  type        = "string"
  description = "subnet to build the jumpbox in"
}

variable "public" {
  type        = "string"
  description = "assign public ip to instance"
  default     = "false"
}

variable "jump_box_allowed_range_enable" {
  type        = "string"
  description = "punch a hole in the security group for a specific ip address cidr"
  default     = "false"
}

variable "jump_box_allowed_range" {
  type        = "string"
  description = "allowed cidr range to access the jumpbox"
  default     = ""
}
