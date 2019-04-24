provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
}

// sets up a single az vpc and a keypair
module "base" {
  source = "../base"

  namespace   = "${var.project_name}"
  module_name = "${var.project_name}"
}

variable "project_name" {
  type    = "string"
  default = "ecs-cloudwatch"
}

module "ecs_cluster" {
  source          = "../../ecs_cluster"
  instance_id     = "2"
  instance_type   = "t2.micro"
  ec2_key_pair    = "${module.base.aws_key_pair_key_name}"
  project_name    = "${var.project_name}"
  environment     = "test"
  vpc_id          = "${module.base.vpc_vpc_id}"
  public_subnets  = "${module.base.vpc_public_subnets}"
  private_subnets = "${module.base.vpc_private_subnets}"
}

data "aws_kms_alias" "key" {
  name = "alias/test"
}

module "sns_alerts" {
  source = "../../sns_alerts"

  project_name      = "${var.project_name}"
  environment       = "test"
  vpc_id            = "${module.base.vpc_vpc_id}"
  private_subnets   = "${module.base.vpc_private_subnets}"
  security_group    = "${module.base.aws_security_group}"
  kms_key_alias_arn = "${data.aws_kms_alias.key.arn}"

  sns_to_slack_channel_mapping = {
    ecs-cluster-alert-topic = "#test-monitoring"
  }

  encrypted_slack_webhook_url = "AQECAHjl1QBQxYpegulpOE3mwmJVcwCfECJkIBhp1DNlm4QkZgAAAKcwgaQGCSqGSIb3DQEHBqCBljCBkwIBADCBjQYJKoZIhvcNAQcBMB4GCWCGSAFlAwQBLjARBAxSvmSo3Mkuel5Pk/oCARCAYBcJ7pjEKRMQPcCpbYqF9XwMD6a7ee9pcyeg755yotEPuPqf7RyZoidN0zTMYSi3hgnTwZcz/YLSVvD3LSmrQXA13WYIs/SNwzeHbzzetV4DzcbCXSGDe0dwxCqtep2JFA=="
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "test-log-group"

  tags {
    Environment = "test"
    Application = "${var.project_name}"
  }
}

module "ecs_cluster_cloudwatch" {
  source              = "../../ecs_cluster_cloudwatch"
  project_name        = "${var.project_name}"
  sns_major_topic_arn = "${module.sns_alerts.sns_topic_arn}"
  sns_minor_topic_arn = "${module.sns_alerts.sns_topic_arn}"

  environment = "test"

  aws_asg_name = "${module.ecs_cluster.aws_asg_name}"
}
