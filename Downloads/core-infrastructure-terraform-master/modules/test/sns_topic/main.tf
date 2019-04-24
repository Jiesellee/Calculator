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

module "sns_alerts" {
  source = "../../sns_topic"

  project_name = "${var.project_name}"
  environment  = "${var.environment}"

  sns_topic_names = "${var.sns_topic_names}"
}
