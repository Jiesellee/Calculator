# the project name
variable "project_name" {
  description = "The name of the project"
}

# the project domain
variable "project_domain" {
  description = "The domain used for the service"
}

# the environment
variable "environment" {
  description = "The environment the cluster is running in"
}

# the VPC to create infra in
variable "vpc_id" {
  description = "The id of the VPC the cluster should be in"
}

variable "public_subnets" {
  type        = "list"
  description = "Public subnets the external oauth2 proxy loadbalancer should be in"
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

// config passed into concourse as environment variables
variable "config_external_url" {
  type        = "string"
  description = "url you will call in your browser to access concourse"
}

variable "config_postgres_encrypted_password" {
  type        = "string"
  description = "optional kms encrypted blob"
}

variable "config_basic_auth_encrypted_password" {
  type        = "string"
  description = "optinal kms encrypted blob"
}

variable "config_github_auth_client_id" {
  type        = "string"
  description = "Configure concourse to use github auth against an orgs team"
}

variable "config_github_auth_client_secret" {
  type        = "string"
  description = "Configure concourse to use github auth against an orgs team"
}

variable "config_github_auth_team" {
  type        = "string"
  description = ""
  default     = "River-Island/microservices"
}

variable "web_additional_env_vars" {
  type        = "string"
  description = "environment variable json statements for the web ecs task"
  default     = ""
}

variable "kms_key_arn" {
  type        = "string"
  description = "arn of the KMS key used to encrypt the below keys"
}

variable "encrypted_keys" {
  type        = "map"
  description = "KMS encrypted keys used for concourse to communicatie"
}

variable "postgres_multi_az" {
  type        = "string"
  description = "make postgres multi az"
  default     = "true"
}

variable "postgres_skip_final_snapshot" {
  type        = "string"
  description = "skip creating final rds snapshot"
  default     = "false"
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

variable "ecs_web_cpu" {
  type        = "string"
  description = "Share of the instance's CPU (out of 1024) for the concourse web container"
  default     = "256"
}

variable "ecs_web_memory" {
  type        = "string"
  description = "Amount of memory (in MB) for the concourse web container"
  default     = "512"
}

variable "ecs_worker_cpu" {
  type        = "string"
  description = "Share of the instance's CPU (out of 1024) for the concourse worker container"
  default     = "1024"
}

variable "ecs_worker_memory" {
  type        = "string"
  description = "Amount of memory (in MB) for the concourse worker container"
  default     = "4096"
}

variable "ecs_instance_type" {
  type        = "string"
  description = "The type of the aws ec2 instance that ecs runs on"
  default     = "i3.xlarge"
}

variable "transit_vpc_subnet_cidr" {
  type        = "string"
  description = "cidr of the transit vpc to allow traffic to the concourse elb"
  default     = ""
}

variable "snapshot_identifier" {
  type        = "string"
  description = "identifier for the snapshot to create the DB from"
  default     = ""
}

variable "concourse_version" {
  type        = "string"
  description = "concourse ci docker image version fetched from dockerhub"
  default     = "2.7.7"
}

variable "concourse_init_version" {
  type        = "string"
  description = "concourse init container version"
  default     = "0.0.3"
}

variable "concourse_ecs_min_size" {
  type        = "string"
  description = "the minimum size of the concourse autoscaling group that spawns ECS instances"
  default     = "1"
}

variable "concourse_ecs_max_size" {
  type        = "string"
  description = "the maximum size of the concourse autoscaling group that spawns ECS instances"
  default     = "1"
}

variable "concourse_ecs_desired_capacity" {
  type        = "string"
  description = "the desired capacity for the concourse autoscaling group that spawns ECS instances"
  default     = "1"
}

variable "concourse_atc_service_count" {
  type        = "string"
  description = "the desired number of concourse ATC service instances"
  default     = "1"
}

variable "number_of_workers" {
  description = "The number of workers ecs will spin up for concourse."
  default     = 2
}
