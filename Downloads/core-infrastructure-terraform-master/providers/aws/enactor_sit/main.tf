terraform {
  backend "s3" {
    bucket  = "dev-core-tf-state"
    key     = "enactor-sit/terraform.tfstate"
    region  = "eu-west-1"
    profile = "ri-dev"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "ri-root"

  // only allow terraform to run in this account it
  allowed_account_ids = ["543766059565"]

  assume_role {
    role_arn = "arn:aws:iam::543766059565:role/OrganizationAccountAccessRole"
  }
}

data "aws_iam_policy_document" "operations_override_policy_document" {
  statement {
    actions = [
      "rds:CreateDBSnapshot",
      "rds:CreateDBInstance",
      "rds:CreateDBClusterSnapshot",
      "rds:RestoreDBInstanceToPointInTime",
      "rds:RestoreDBInstanceFromDBSnapshot",
      "rds:RestoreDBClusterFromSnapshot",
      "rds:RebootDBInstance",
      "rds:ApplyPendingMaintenanceAction",
      "ec2:TerminateInstances",
      "ecs:StopTask",
      "ecs:UpdateService",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "operations_override_policy" {
  name   = "operations_override_policy"
  policy = "${data.aws_iam_policy_document.operations_override_policy_document.json}"
}

variable "environment" {
  type        = "string"
  description = "the environment of the account"
  default     = "sit"
}

variable "project_name" {
  type        = "string"
  description = "describe your variable"
  default     = "enactor"
}

module "iam_member_account" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/iam_member_account?ref=6edb4acaf3ef0358bef21d71d29e502536df5d7f"

  override_operations_role_policy     = "true"
  override_operations_role_policy_arn = "${aws_iam_policy.operations_override_policy.arn}"

  aws_iam_root_account_id           = "667800118351"
  aws_product_management_account_id = "350793678069"
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
