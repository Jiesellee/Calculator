terraform {
  backend "s3" {
    bucket  = "dev-core-tf-state"
    key     = "iam/terraform.tfstate"
    region  = "eu-west-1"
    profile = "ri-dev"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "ri-root"
  version = "= v1.14.0"

  // only allow terraform to run in this account it
  allowed_account_ids = ["667800118351"]

  assume_role {
    role_arn = "arn:aws:iam::667800118351:role/OrganizationAccountAccessRole"
  }
}

module "cloudtrail_member_account" {
  source = "../../../modules/cloudtrail_member_account"
}

// allow iam developers to manage IAM users passwords and virtual MFA devices.
// This is all sent to cloudtrail and you can't alter policies!
data "aws_iam_policy_document" "developer_override_policy_document" {
  statement {
    actions = [
      "iam:List*",
      "iam:Get*",
      "iam:ChangePassword",
      "iam:UpdateLoginProfile",
      "iam:DeactivateMFADevice",
      "iam:DeleteVirtualMFADevice",
    ]

    resources = [
      "*",
    ]
  }

  // allow developers to assume all developer roles in all accounts.
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/developers"]
  }
}

resource "aws_iam_policy" "developer_override_policy" {
  name   = "developer_override_policy"
  policy = "${data.aws_iam_policy_document.developer_override_policy_document.json}"
}

module "iam_member_account" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/iam_member_account?ref=6edb4acaf3ef0358bef21d71d29e502536df5d7f"

  aws_iam_root_account_id = "667800118351"

  override_developer_role_policy     = "true"
  override_developer_role_policy_arn = "${aws_iam_policy.developer_override_policy.arn}"
}
