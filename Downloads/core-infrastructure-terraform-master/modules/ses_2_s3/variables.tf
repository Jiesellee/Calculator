variable "environment" {
  type        = "string"
  description = "name of the environment"
}

variable "project_name" {
  type        = "string"
  description = "name of the project"
}

variable "resource_tags" {
  type        = "map"
  description = "add aditional resource tags here such as cost center or anything to add to all taggable resources"
  default     = {}
}

variable "domain" {
  type        = "string"
  description = "describe your variable"
  default     = "false"
}

variable "route53_zone_id" {
  type        = "string"
  description = "zone id to create the verification record in"
}
