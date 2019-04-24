variable "region" {
  description = "The region the AWS resources will run in"
  default     = "eu-west-1"
}

variable "ecs_instance_type" {
  type        = "string"
  description = "The type of the aws ec2 instance that ecs runs on"
  default     = "c4.large"
}

variable "ecr_repo_concourse_ci_allowed_aws_accounts_ro" {
  type        = "list"
  description = "read only access to concourse ci ecr repo"
  default     = []
}

variable "project_name" {
  type        = "string"
  description = "Name of the project"
  default     = "management"
}

variable "environment" {
  type        = "string"
  description = "environment"
  default     = "prod"
}

# the namespace
variable "namespace" {
  type        = "string"
  description = "a string to be used as the prefix for various AWS resources"
  default     = "b529870"
}

variable "vault_managed_uuid" {
  type        = "string"
  description = "a string to be used as the prefix for various AWS resources"
  default     = "v2103"
}

variable "bucket_purpose" {
  type        = "string"
  description = "suffix to be added to the name of the s3 bucket which holds the states for vaultguard"
  default     = "vaultguard"
}

variable "module_instance_id" {
  type        = "string"
  description = "module id enabling multiple invocations of the module in the same account avoiding resource naming clashes"
  default     = "0"
}

variable "aws_ssh_key_file" {
  type        = "string"
  description = "describe your variable"
  default     = "default"
}

variable "private_subnets" {
  type        = "list"
  description = "private subnet cidrs"
  default     = ["10.202.100.0/24", "10.202.101.0/24"]
}

variable "public_subnets" {
  type        = "list"
  description = "public subnet cidrs"
  default     = ["10.202.102.0/24", "10.202.103.0/24"]
}

variable "vpc_cidr" {
  type        = "string"
  description = "vpc cidr"
  default     = "10.202.100.0/22"
}

variable "concourse_ecs_min_size" {
  type        = "string"
  description = "the minimum size of the concourse autoscaling group that spawns ECS instances"
  default     = "1"
}

variable "concourse_ecs_max_size" {
  type        = "string"
  description = "the maximum size of the concourse autoscaling group that spawns ECS instances"
  default     = "3"
}

variable "concourse_ecs_desired_capacity" {
  type        = "string"
  description = "the desired capacity for the concourse autoscaling group that spawns ECS instances"
  default     = "1"
}

// vpc_peering - prod transit
variable "prod_transit_vpc_peering" {
  type        = "string"
  description = "Peer to the transit vpc in another account"
  default     = false
}

variable "prod_transit_vpc_account_id" {
  type        = "string"
  description = "the id of the account that the transit vpc sits in"
  default     = "376076567968"
}

variable "prod_transit_vpc_id" {
  type        = "string"
  description = "the id of the transit vpc that has the direct connect connection attached"
  default     = "vpc-2efefe4a"
}

variable "prod_transit_vpc_subnet_cidr" {
  type        = "string"
  description = "CIDR of vpc subnet to route to"
  default     = "10.202.0.0/22"
}

variable "dev_transit_vpc_peering" {
  type        = "string"
  description = "Peer to the transit vpc in another account"
  default     = false
}

variable "dev_transit_vpc_account_id" {
  type        = "string"
  description = "the id of the account that the transit vpc sits in"
  default     = "556748783639"
}

variable "dev_transit_vpc_id" {
  type        = "string"
  description = "the id of the transit vpc that has the direct connect connection attached"
  default     = "vpc-2ee35b4a"
}

variable "dev_transit_vpc_subnet_cidr" {
  type        = "string"
  description = "CIDR of vpc subnet to route to"
  default     = "10.201.0.0/16"
}

variable "concourse_atc_service_count" {
  type        = "string"
  description = "the desired number of concourse ATC service instances"
  default     = "2"
}

// end vpc_peering

variable "ecs_vault_cpu" {
  type        = "string"
  description = "Share of the instance's CPU (out of 1024) for the vault container"
  default     = "1024"
}

variable "ecs_vault_mem" {
  type        = "string"
  description = "Amount of memory (in MB) for the vault container"
  default     = "2048"
}

variable "ecs_vault_managed_vault_cpu" {
  type        = "string"
  description = "Share of the instance's CPU (out of 1024) for the vault container"
  default     = "512"
}

variable "ecs_vault_managed_vault_mem" {
  type        = "string"
  description = "Amount of memory (in MB) for the vault container"
  default     = "2048"
}

variable "ecs_vaultguard_cpu" {
  type        = "string"
  description = "Share of the instance's CPU (out of 1024) for the vault container"
  default     = "512"
}

variable "ecs_vaultguard_mem" {
  type        = "string"
  description = "Amount of memory (in MB) for the vault container"
  default     = "256"
}

variable "ecs_service_name_vault" {
  type        = "string"
  description = "ECS service name"
  default     = "vault"
}

variable "ecs_service_name_vaultguard" {
  type        = "string"
  description = "ECS service name"
  default     = "vaultguard"
}

variable "dynamodb_read_capacity" {
  type        = "string"
  description = "arn of the KMS key used to encrypt the TLS assets"
  default     = "10"
}

variable "dynamodb_write_capacity" {
  type        = "string"
  description = "arn of the KMS key used to encrypt the TLS assets"
  default     = "5"
}

variable "vault_encrypted_keys" {
  type = "map"

  default = {
    // kms encrypted vault.pem
    vault_pem = "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"

    // kms encrypted vault-key.pem
    vault_key_pem = "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"

    // kms encrypted vault_ca.pem
    vault_ca_pem = "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"
  }
}
