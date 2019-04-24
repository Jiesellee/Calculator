provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
  version             = "=1.2.0"
}

// sets up a single az vpc and a keypair
module "base" {
  source = "../base"

  namespace           = "${var.namespace}"
  module_name         = "vault-ci"
  jump_box_allowed_ip = "193.105.212.250"
}

data "aws_ami" "aws_ecs_optimised_latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

// vault module

module "vault" {
  source = "../../vault"

  project_name      = "${var.project_name}"
  environment       = "${var.environment}"
  namespace         = "${var.namespace}"
  bucket_purpose    = "${var.bucket_purpose}"
  vpc_id            = "${module.base.vpc_vpc_id}"
  private_subnets   = "${module.base.vpc_private_subnets}"
  vpc_subnet        = "${module.base.vpc_cidr}"
  aws_asg_image_id  = "${data.aws_ami.aws_ecs_optimised_latest.id}"
  ec2_key_pair      = "${module.base.aws_key_pair_key_name}"
  region            = "${var.region}"
  ecs_instance_type = "${var.ecs_instance_type}"

  ecs_vault_cpu  = "${var.ecs_vault_cpu}"
  ecs_vault_mem  = "${var.ecs_vault_mem}"
  route53_zoneid = "${module.base.zone_id}"

  kms_key_arn = "arn:aws:kms:eu-west-1:460402331925:key/4c4899af-2a3b-4ca2-a82d-78863371bb07"

  vault_encrypted_keys = "${var.vault_encrypted_keys}"

  // s3 settings
  dynamodb_write_capacity = "${var.dynamodb_write_capacity}"
  dynamodb_read_capacity  = "${var.dynamodb_read_capacity}"

  enable_vaultguard                = true
  vaultguard_version               = "v0.0.27"
  namespace_log_group              = true
  namespace_dynamodb_table         = true
  vaultguard_managed_vault_cluster = "${format("%s-%s-%s-vault-ecs", var.project_name, var.environment, var.namespace)}"
}

// vault module

output "aws_key_pair_private_key" {
  value = "${module.base.aws_key_pair_private_key}"
}

output "jump_box_ip" {
  value = "${module.base.jump_box_ip}"
}

output "vault_tls_endpoint" {
  value = "${module.vault.vault_tls_endpoint}"
}
