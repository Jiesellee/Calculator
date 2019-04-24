terraform {
  backend "s3" {
    bucket = "dev-core-tf-state"
    key    = "product_management/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"

  // only allow terraform to run in this account it
  allowed_account_ids = ["125479865773"]

  assume_role {
    role_arn = "arn:aws:iam::125479865773:role/OrganizationAccountAccessRole"
  }
}

variable "environment" {
  type        = "string"
  description = "the environment of the account"
  default     = "management"
}

variable "project_name" {
  type        = "string"
  description = "describe your variable"
  default     = "product"
}

module "iam_member_account" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/iam_member_account?ref=6edb4acaf3ef0358bef21d71d29e502536df5d7f"

  aws_iam_root_account_id           = "667800118351"
  aws_product_management_account_id = "125479865773"
}

module "s3_state_bucket" {
  source       = "../../../modules/s3_state_bucket"
  environment  = "${var.environment}"
  project_name = "${var.project_name}"
}

module "cloudtrail_member_account" {
  source = "../../../modules/cloudtrail_member_account"
}
