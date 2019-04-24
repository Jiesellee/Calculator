terraform {
  backend "s3" {
    bucket  = "dev-core-tf-state"
    key     = "management/terraform.tfstate"
    region  = "eu-west-1"
    profile = "ri-dev"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "ri-root"

  // only allow terraform to run in this account it
  allowed_account_ids = ["002540887416"]

  assume_role {
    role_arn = "arn:aws:iam::002540887416:role/OrganizationAccountAccessRole"
  }
}

module "management" {
  source = "../../../modules/management_account"

  // we should fetch these from a data source once aws orgs are created.
  // read only to concourse-ci ecr repo
  ecr_repo_concourse_ci_allowed_aws_accounts_ro = [
    "728741135697", // rfid management account
    "667800118351", // main management account
    "350793678069", // enactor management account
    "710660959603", // order management account
    "713021333007", // payment management account
    "460402331925", // test account
    "125479865773", // product management account
  ] // IAM account for all users to get ro
}

resource "aws_iam_policy" "developer_override_policy" {
  name   = "developer_override_policy"
  policy = "${data.aws_iam_policy_document.developer_override_policy_document.json}"
}

data "aws_iam_policy_document" "developer_override_policy_document" {
  // allow devs to put, get and delete objects to specific buckets we care about.
  statement {
    actions = [
      "s3:PutObject*",
      "s3:DeleteObject*",
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      "arn:aws:s3:::management-admin-tf-state",
      "arn:aws:s3:::management-admin-tf-state/*",
      "arn:aws:s3:::management-prod-concourse-versions",
      "arn:aws:s3:::management-prod-concourse-versions/*",
      "arn:aws:s3:::prod-core-shared-assets",
      "arn:aws:s3:::prod-core-shared-assets/*",
    ]
  }
}

module "iam_member_account" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/iam_member_account?ref=6edb4acaf3ef0358bef21d71d29e502536df5d7f"

  override_developer_role_policy     = "true"
  override_developer_role_policy_arn = "${aws_iam_policy.developer_override_policy.arn}"

  aws_iam_root_account_id = "667800118351"
}

output "s3_shared_assets_bucket_name" {
  value = "${module.management.s3_shared_assets_bucket_name}"
}

module "cloudtrail_member_account" {
  source = "../../../modules/cloudtrail_member_account"
}
