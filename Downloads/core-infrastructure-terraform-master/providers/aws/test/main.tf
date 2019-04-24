terraform {
  backend "s3" {
    bucket  = "dev-core-tf-state"
    key     = "test/terraform.tfstate"
    region  = "eu-west-1"
    profile = "ri-dev"
  }
}

provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
  profile             = "ri-root"

  assume_role {
    role_arn = "arn:aws:iam::460402331925:role/OrganizationAccountAccessRole"
  }
}

variable "environment" {
  type        = "string"
  description = "the environment of the account"
  default     = "main"
}

variable "project_name" {
  type        = "string"
  description = "describe your variable"
  default     = "test"
}

module "iam_member_account" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/iam_member_account?ref=6edb4acaf3ef0358bef21d71d29e502536df5d7f"

  developers_full_access     = "true"
  aws_iam_root_account_id    = "667800118351"
  aws_monitoring_account_ids = ["376076567968", "556748783639"] // prod and dev accounts
}

resource "aws_route53_zone" "environment" {
  name = "${var.environment}.${var.project_name}.ri-tech.io"

  tags {
    "terraform"    = "true"
    "environment"  = "${var.environment}"
    "project_name" = "${var.project_name}"
  }
}

module "cloudtrail_member_account" {
  source = "../../../modules/cloudtrail_member_account"
}

module "s3_state_bucket" {
  source       = "../../../modules/s3_state_bucket"
  environment  = "${var.environment}"
  project_name = "${var.project_name}"
}

output "route53_name_servers" {
  value = "${aws_route53_zone.environment.name_servers}"
}
