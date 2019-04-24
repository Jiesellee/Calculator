// alb variables
variable "listener_arn" {
  description = "arn of the alb listener"
  default     = ""
}

variable "listener_ssl_arn" {
  description = "arn of the ssl alb listener"
  default     = ""
}

variable "vpc_id" {
  description = "ID of the VPC this sits in"
}

variable "priority" {
  description = "The priotiry of the rule"
}

variable "health_check_path" {
  // change to /ping when impliemnted
  default = "/"
}

variable "alb_routing_method" {
  description = "Routing method; Must be path-pattern or host-header"
  type        = "string"
  default     = "host-header"
}

variable "alb_routing_pattern" {
  description = "Your path-pattern or host-header that you want to route on"
  type        = "string"
}

// ecs variables
variable "aws_ecs_cluster_arn" {
  description = "ID of the ECS cluster"
}

variable "service_name" {
  description = "Name of the ECS service"
}

variable "service_port" {
  type        = "string"
  description = "Default container port the service listens on"
  default     = "8080"
}

variable "ecs_task_definition" {
  description = "rendered ecs task definition in json"
}

variable "task_policy" {
  description = "enable attaching an additional policy to the ECS task definition"
  default     = "false"
}

variable "task_policy_arn" {
  description = "additional policy ARN to attach to the ECS task definition"
  default     = ""
}

variable "efs_host_path" {
  description = "folder where efs volume is going to be mounted"
  default     = "/mnt/efs"
}

variable "desired_task_count" {
  description = "The desired count of running tasks. This is useful for ensuring uptime."
  default     = 1
}

// iam variables

variable "project_name" {
  description = "project name to tag resources with"
}

variable "environment" {
  description = "environment name to tag resources with"
}

variable "ecs_service_deployment_minimum_healthy_percent" {
  description = "minimum percentage of containers to remain active during a deploy"
  default     = "50"
}

variable "ecs_service_deployment_maximum_percent" {
  description = "maximum percentage of containers to remain active during a deploy"
  default     = "100"
}

variable "ecs_service_desired_task_count" {
  description = "desired number of containers (tasks) that should be active"
  default     = "2"
}

variable "zone_id" {
  description = "dns zone id for ecs cluster"
}

variable "alb_dns_name" {
  description = "DNS for the alb"
}

variable "target_group_hack" {
  default     = ""
  description = "If provided, this param will serve as the name of the target group. It does not do this by default to stop downtime in older services"
}

variable "enable_http_listener" {
  description = "creates a target for the load balancer http listener"
  default     = true
}

variable "enable_https_listener" {
  description = "creates a target for the load balancer https listener"
  default     = false
}
