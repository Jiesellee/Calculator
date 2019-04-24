# the project name
variable "project_name" {
  description = "The name of the project"
}

# the environment
variable "environment" {
  description = "The environment the cluster is running in"
}

# the namespace
variable "namespace" {
  type        = "string"
  description = "a string to be used as the prefix for various AWS resources"
  default     = ""
}

variable "bucket_purpose" {
  type        = "string"
  description = "s3 bucket to be used to hold the state for vaultguard"
  default     = ""
}

# the log_group namespace
variable "namespace_log_group" {
  type        = "string"
  description = "a string to be used as the prefix for various AWS resources"
  default     = false
}

# the dynamodb namespace
variable "namespace_dynamodb_table" {
  type        = "string"
  description = "a string to be used as the prefix for the vault dynamodb table"
  default     = false
}

variable "vaultguard_managed_vault_cluster" {
  type        = "string"
  description = "the target vault cluster that vaultguard will manage"
  default     = ""
}

# the VPC to create infra in
variable "vpc_id" {
  description = "The id of the VPC the cluster should be in"
}

variable "region" {
  description = "The region the AWS resources will run in"
}

variable "private_subnets" {
  type        = "list"
  description = "Internal subnets the ecs cluster should be in"
}

variable "vpc_subnet" {
  description = "Subnet range to firewall off the ecs cluster into"
}

variable "ec2_key_pair" {
  description = "Keypair for the created instances"
}

# aws ec2 image to use for the asg
variable "aws_asg_image_id" {
  type = "string"

  // TODO: use ami resource to find latest and greatest.
  // look for new ones here http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
  default = "ami-ff15039b"

  description = "ecs optimised ec2 ami"
}

variable "ecs_instance_type" {
  type        = "string"
  description = "The type of the aws ec2 instance that ecs runs on"
  default     = "t2.micro"
}

variable "transit_vpc_subnet_cidr" {
  type        = "string"
  description = "CIDR of the transit vpc to allow traffic to the vault elb. This CIDR must be different than the one in the private_subnet"
  default     = ""
}

variable "route53_zoneid" {
  type        = "string"
  description = "The route53 zone id to create the vault record in"
}

// ecs iam
variable "additional_ecs_instance_role_policy" {
  type        = "string"
  description = "a json policy document for the ecs instance role policy"
  default     = "false"
}

variable "additional_ecs_service_role_policy" {
  type        = "string"
  description = "a json policy document for the ecs service role policy"
  default     = "false"
}

variable "ecs_vault_cpu" {
  type        = "string"
  description = "Share of the instance's CPU (out of 1024 * vCPUs ) for the vault container"
}

variable "ecs_vault_mem" {
  type        = "string"
  description = "Amount of memory (in MB) for the vault container"
}

variable "enable_vaultguard" {
  type        = "string"
  description = "Enable the vault manager"
  default     = false
}

variable "vaultguard_version" {
  type        = "string"
  description = "Vaultguard manager version"
  default     = ""
}

variable "ecs_vaultguard_cpu" {
  type        = "string"
  description = "Share of the instance's CPU (out of 1024) for the vault container"
  default     = "256"
}

variable "ecs_vaultguard_mem" {
  type        = "string"
  description = "Amount of memory (in MB) for the vault container"
  default     = "256"
}

variable "kms_key_arn" {
  type        = "string"
  description = "arn of the KMS key used for encryption"
}

variable "vault_encrypted_keys" {
  type        = "map"
  description = "KMS encrypted TLS assets used by vault."
}

variable "dynamodb_read_capacity" {
  type        = "string"
  description = "read capacity for dynamodb table"
  default     = "5"
}

variable "dynamodb_write_capacity" {
  type        = "string"
  description = "write capacity for dynamodb table"
  default     = "5"
}
