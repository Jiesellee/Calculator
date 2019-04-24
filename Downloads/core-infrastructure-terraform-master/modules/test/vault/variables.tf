# the project name
variable "project_name" {
  description = "The name of the project"
  default     = "cd8c095"
}

# the environment
variable "environment" {
  description = "The environment the cluster is running in"
  default     = "circleci"
}

variable "namespace" {
  type        = "string"
  description = "The namespace used to create different names for EC2 key pairs, and other resources."
  default     = "cd8c"
}

variable "bucket_purpose" {
  type        = "string"
  description = "suffix to be added to the name of the s3 bucket which holds the states for vaultguard"
  default     = "vaultguard"
}

variable "region" {
  description = "The region the AWS resources will run in"
  default     = "eu-west-1"
}

variable "ecs_instance_type" {
  type        = "string"
  description = "The type of the aws ec2 instance that ecs runs on"
  default     = "t2.micro"
}

variable "ecs_vault_cpu" {
  type        = "string"
  description = "Share of the instance's CPU (out of 1024) for the vault container"
  default     = "256"
}

variable "ecs_vault_mem" {
  type        = "string"
  description = "Amount of memory (in MB) for the vault container"
  default     = "512"
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
