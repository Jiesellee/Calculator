variable "private_subnet_tags" {
  type        = "map"
  description = "tags to apply to the private subnets"
  default     = {}
}

variable "public_subnet_tags" {
  type        = "map"
  description = "tags to apply to the public subnets"
  default     = {}
}

variable "module_name" {
  type        = "string"
  description = "name of the module being tested"
  default     = "base"
}

variable "namespace" {
  default     = "c1abd721-circleci"
  description = "Specify a namespace for the vpc"
}

variable "cidr_namespace" {
  default     = "0"
  description = "Number 0-255 of the cidr namespace to allocate"
}

variable "jump_box_allowed_ip" {
  type        = "string"
  description = "public ip for shoreditch ritechhq wifi"
  default     = "193.105.212.250"
}
