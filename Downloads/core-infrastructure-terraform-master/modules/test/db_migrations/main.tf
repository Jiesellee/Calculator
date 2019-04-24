provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
  version             = "= 1.6.0"
}

// sets up a single az vpc and a keypair
module "base" {
  source = "../base"

  namespace           = "${var.project_name}"
  module_name         = "${var.project_name}"
  jump_box_allowed_ip = "82.47.237.181"
}

variable "project_name" {
  type    = "string"
  default = "ecs-db-migrations"
}

module "ecs_cluster" {
  source          = "../../ecs_cluster"
  instance_id     = "2"
  instance_type   = "t2.large"
  ec2_key_pair    = "${module.base.aws_key_pair_key_name}"
  project_name    = "${var.project_name}"
  environment     = "test"
  vpc_id          = "${module.base.vpc_vpc_id}"
  public_subnets  = "${module.base.vpc_public_subnets}"
  private_subnets = "${module.base.vpc_private_subnets}"
}

module "db_migrations" {
  source        = "../../db_migrations"
  service_name  = "${var.project_name}"
  ecr_image_tag = "latest"
  ecr_image     = "willejs/sql_migration"
  service_name  = "test"
  db_name       = "test"
  db_username   = "test"
  db_password   = "test"
  db_url        = "test"
}

output "ecs_cluster_arn" {
  value = "${module.ecs_cluster.aws_ecs_cluster_arn}"
}

output "aws_ecs_task_definition_name" {
  value = "${module.db_migrations.aws_ecs_task_definition_name}"
}
