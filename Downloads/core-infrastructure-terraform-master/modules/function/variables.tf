variable "vpc_id" {
  description = "The id of the vpc the lambda will run in"
}

variable "environment" {
  description = "The environment where this runs"
}

variable "function_name" {
  description = "The name of the function you are deploying"
}

variable "deployment_package_filename" {
  description = "A relative path to the zip file to deploy"
}

variable "function_description" {
  description = "A lambda function within the order scope"
}

variable "function_runtime" {
  default     = "nodejs4.3"
  description = "The funciton runtime"
}

variable "function_handler" {
  default     = "index.handle"
  description = "The function handler"
}

variable "function_environment_variables" {
  type        = "map"
  description = "A map of environment variables to pass to the lambda function"
}

variable "lambda_memory" {
  default     = "1024"
  description = "The default lambda memory limit"
}

variable "lambda_timeout" {
  default     = "300"
  description = "The default lambda execution timeout"
}

variable "private_subnets" {
  type        = "list"
  description = "A list of the private subnets in which to deploy the lambda"
}

variable "lambda_role_policy" {
  description = "The policy of the role to be applied to the lambda function"
}

variable "default_security_group_id" {
  description = "The id of the security groups to apply to the labda by default"
}

variable "publish_function_versions" {
  description = "Publish new version of function everytime updated"
  default     = "false"
}
