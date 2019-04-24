variable "project_name" {
  description = "name of the project"
}

variable "environment" {
  description = "environment of the project"
}

variable "private_subnets" {
  type        = "list"
  description = "Private subnets the batch service should be in"
}

variable "security_groups" {
  type        = "list"
  description = "Eligible security groups"
}

variable "ec2_key_pair" {
  description = "Keypair for the created instances"
}

variable "ecs_instance_profile" {
  description = "ECS instance profile role"
}

variable "instance_type" {
  description = "Tiny instances for docker containers"
}

variable "min_cpus" {
  description = "Minimum CPUs for batch compute environment"
}

variable "max_cpus" {
  description = "Maximum CPUs for batch compute environment"
}

variable "job_priority" {
  description = "Priority for batch job in the queue"
}

variable "number_of_batch_job_definitions" {
  description = "Number of batch job definitions"
}

variable "batch_job_definitions" {
  type        = "map"
  description = "Rendered batch job definition in json"
}

variable "batch_job_queue_name" {
  description = "Name of batch job queue"
}

variable "batch_job_definition_name" {
  description = "Name of batch job definition"
}

variable "batch_compute_environment_name" {
  description = "Name of batch compute environment"
}
