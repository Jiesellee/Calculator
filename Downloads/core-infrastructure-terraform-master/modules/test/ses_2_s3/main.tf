provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
}

variable "environment" {
  type        = "string"
  description = "test environment"
  default     = "test"
}

variable "project_name" {
  type        = "string"
  description = "test project"
  default     = "test"
}

module "ses_2_s3" {
  source = "../../ses_2_s3"

  project_name    = "${var.project_name}"
  environment     = "${var.environment}"
  route53_zone_id = "${aws_route53_zone.test.zone_id}"
}

resource "aws_route53_zone" "test" {
  name = "test.test.ri-tech.io"
}
