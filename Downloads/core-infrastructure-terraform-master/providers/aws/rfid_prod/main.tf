terraform {
  backend "s3" {
    bucket  = "dev-core-tf-state"
    key     = "rfid_prod/terraform.tfstate"
    region  = "eu-west-1"
    profile = "ri-dev"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "ri-root"

  // only allow terraform to run in this account it
  allowed_account_ids = ["215821541440"]

  assume_role {
    role_arn = "arn:aws:iam::215821541440:role/OrganizationAccountAccessRole"
  }
}

data "aws_iam_policy_document" "developer_override_policy_document" {
  statement {
    actions = [
      "lambda:Invoke*",
      "lambda:UpdateEventSourceMapping",
      "sqs:PurgeQueue",
      "sqs:DeleteMessage*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "developer_override_policy" {
  name   = "developer_override_policy"
  policy = "${data.aws_iam_policy_document.developer_override_policy_document.json}"
}

module "iam_member_account" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/iam_member_account?ref=6edb4acaf3ef0358bef21d71d29e502536df5d7f"

  override_developer_role_policy     = "true"
  override_developer_role_policy_arn = "${aws_iam_policy.developer_override_policy.arn}"

  aws_iam_root_account_id = "667800118351"

  aws_product_management_account_id = "728741135697"
}

module "cloudtrail_member_account" {
  source = "../../../modules/cloudtrail_member_account"
}
