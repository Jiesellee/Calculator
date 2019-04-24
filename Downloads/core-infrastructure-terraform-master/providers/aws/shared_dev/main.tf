terraform {
  backend "s3" {
    bucket  = "dev-core-tf-state"
    key     = "shared_dev/terraform.tfstate"
    region  = "eu-west-1"
    profile = "ri-dev"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "ri-root"

  // only allow terraform to run in this account it
  allowed_account_ids = ["556748783639"]

  assume_role {
    role_arn = "arn:aws:iam::556748783639:role/OrganizationAccountAccessRole"
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
  default     = "shared"
}

module "iam_member_account" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/iam_member_account?ref=6f619a1601e2a0c1ef70611227d3b66ef9b4b83d"

  aws_iam_root_account_id           = "667800118351"
  developers_full_access            = "true"
  aws_product_management_account_id = "002540887416"
}

module "s3_state_bucket" {
  source       = "../../../modules/s3_state_bucket"
  environment  = "${var.environment}"
  project_name = "${var.project_name}"
}

module "cloudtrail_member_account" {
  source = "../../../modules/cloudtrail_member_account"
}
