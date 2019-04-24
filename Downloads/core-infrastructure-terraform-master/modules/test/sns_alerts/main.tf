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
  type        = "string"
  description = "describe your variable"
  default     = "sns-alerts"
}

variable "environment" {
  type        = "string"
  description = "describe your variable"
  default     = "test"
}

module "ecs_service_cloudwatch" {
  source        = "../../ecs_service_cloudwatch"
  project_name  = "${var.project_name}"
  service_name  = "test"
  cluster_name  = "test-cluster-that-does-not-exist"
  sns_topic_arn = "${module.sns_alerts.sns_topic_arn}"
}

data "aws_kms_alias" "key" {
  name = "alias/test"
}

module "sns_alerts" {
  source = "../../sns_alerts"

  project_name      = "${var.project_name}"
  environment       = "${var.environment}"
  vpc_id            = "${module.base.vpc_vpc_id}"
  private_subnets   = "${module.base.vpc_private_subnets}"
  security_group    = "${module.base.aws_security_group}"
  kms_key_alias_arn = "${data.aws_kms_alias.key.arn}"

  sns_to_slack_channel_mapping = {
    ecs-cluster-alert-topic = "#test-monitoring"
  }

  encrypted_slack_webhook_url = "AQECAHjl1QBQxYpegulpOE3mwmJVcwCfECJkIBhp1DNlm4QkZgAAAKcwgaQGCSqGSIb3DQEHBqCBljCBkwIBADCBjQYJKoZIhvcNAQcBMB4GCWCGSAFlAwQBLjARBAxSvmSo3Mkuel5Pk/oCARCAYBcJ7pjEKRMQPcCpbYqF9XwMD6a7ee9pcyeg755yotEPuPqf7RyZoidN0zTMYSi3hgnTwZcz/YLSVvD3LSmrQXA13WYIs/SNwzeHbzzetV4DzcbCXSGDe0dwxCqtep2JFA=="
}
