terraform {
  backend "s3" {
    bucket  = "dev-core-tf-state"
    key     = "pocs/terraform.tfstate"
    region  = "eu-west-1"
    profile = "ri-dev"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "ri-root"

  // only allow terraform to run in this account it
  allowed_account_ids = ["168416847939"]

  assume_role {
    role_arn = "arn:aws:iam::168416847939:role/OrganizationAccountAccessRole"
  }
}

variable "environment" {
  type        = "string"
  description = "the environment of the account"
  default     = "dev"
}

variable "project_name" {
  type        = "string"
  description = "describe your variable"
  default     = "pocs"
}

module "iam_member_account" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/iam_member_account?ref=6edb4acaf3ef0358bef21d71d29e502536df5d7f"

  aws_iam_root_account_id = "667800118351"

  // management account id as pocs is managed by management!
  aws_product_management_account_id = "002540887416"
  developers_full_access            = "true"
}

module "s3_state_bucket" {
  source       = "../../../modules/s3_state_bucket"
  environment  = "${var.environment}"
  project_name = "${var.project_name}"
}

module "cloudtrail_member_account" {
  source = "../../../modules/cloudtrail_member_account"
}
