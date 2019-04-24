variable "instance_type" {
  default     = "t2.medium"
  description = "Tiny instances for docker containers"
}

variable "ec2_key_pair" {
  description = "ec2 keypair to use with the ECS instances"
}

variable "instance_id" {
  description = "the unique instance id of the module"
}

variable "project_name" {
  description = "name of the project"
}

variable "environment" {
  description = "environment of the project"
}

variable "vpc_id" {
  description = "VPC id"
}

variable "private_subnets" {
  description = "private subnets for ECS cluster nodes"
  type        = "list"
}

variable "public_subnets" {
  description = "public subnets for AWS ALB"
  type        = "list"
}

variable "ecs_image_id" {
  // look for new ones here http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
  default     = "ami-a7f2acc1"
  description = "ecs optimised ec2 ami"
}

variable "alb_allowed_cidr_blocks" {
  description = "list of allowed IPs on the ELB created"
  default     = ["10.0.0.0/8"]
}

// asg

variable "additional_cloud_config" {
  type        = "string"
  description = "additional cloud config in cloud for the ec2 instances"
  default     = ""
}

variable "additional_asg_ingress_security_group" {
  type        = "string"
  description = "add additional security groups to asg instances ingres"
  default     = ""
}

//ssl
variable "enable_elb_ssl" {
  description = "enables lb https listener with the given ssl certificate"
  default     = false
}

variable "ssl_policy" {
  description = "ssl policy for https lb listener"
  default     = "ELBSecurityPolicy-2016-08"
}

variable "ssl_certificate_arn" {
  description = "ssl certificate arn for https lb listener"
  default     = ""
}
