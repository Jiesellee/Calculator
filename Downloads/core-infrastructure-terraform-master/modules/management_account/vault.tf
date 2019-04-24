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

module "vault" {
  source = "../vault"

  project_name      = "${var.project_name}"
  environment       = "${var.environment}"
  bucket_purpose    = "${var.bucket_purpose}"
  vpc_id            = "${module.vpc.vpc_id}"
  private_subnets   = "${module.vpc.private_subnets}"
  vpc_subnet        = "${module.vpc.vpc_cidr_block}"
  aws_asg_image_id  = "${data.aws_ami.aws_ecs_optimised_latest.id}"
  ec2_key_pair      = "${aws_key_pair.default.key_name}"
  region            = "${var.region}"
  ecs_instance_type = "${var.ecs_instance_type}"

  ecs_vault_cpu  = "${var.ecs_vault_cpu}"
  ecs_vault_mem  = "${var.ecs_vault_mem}"
  route53_zoneid = "${aws_route53_zone.management.zone_id}"

  // manually defined key used for testing in circleci
  kms_key_arn          = "${aws_kms_key.concourse_ci.arn}"
  vault_encrypted_keys = "${var.vault_encrypted_keys}"

  dynamodb_write_capacity = "${var.dynamodb_write_capacity}"
  dynamodb_read_capacity  = "${var.dynamodb_read_capacity}"
}

module "vault_managed" {
  source = "../vault"

  project_name      = "${var.project_name}"
  environment       = "${var.environment}"
  namespace         = "${var.vault_managed_uuid}"
  bucket_purpose    = "${var.bucket_purpose}"
  vpc_id            = "${module.vpc.vpc_id}"
  private_subnets   = "${module.vpc.private_subnets}"
  vpc_subnet        = "${module.vpc.vpc_cidr_block}"
  aws_asg_image_id  = "${data.aws_ami.aws_ecs_optimised_latest.id}"
  ec2_key_pair      = "${aws_key_pair.default.key_name}"
  region            = "${var.region}"
  ecs_instance_type = "${var.ecs_instance_type}"

  ecs_vault_cpu  = "${var.ecs_vault_managed_vault_cpu}"
  ecs_vault_mem  = "${var.ecs_vault_managed_vault_mem}"
  route53_zoneid = "${aws_route53_zone.management.zone_id}"

  // manually defined key used for testing in circleci
  kms_key_arn          = "${aws_kms_key.concourse_ci.arn}"
  vault_encrypted_keys = "${var.vault_encrypted_keys}"

  dynamodb_write_capacity = "${var.dynamodb_write_capacity}"
  dynamodb_read_capacity  = "${var.dynamodb_read_capacity}"

  enable_vaultguard                = true
  vaultguard_version               = "v0.0.27"
  vaultguard_managed_vault_cluster = "${format("%s-%s-%s-vault-ecs", var.project_name, var.environment, var.vault_managed_uuid)}"

  ecs_vault_cpu            = "${var.ecs_vault_managed_vault_cpu}"
  ecs_vault_mem            = "${var.ecs_vault_managed_vault_mem}"
  namespace_log_group      = true
  namespace_dynamodb_table = true
}
