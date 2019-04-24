terraform {
  backend "s3" {
    bucket  = "dev-core-tf-state"
    key     = "order_staging/terraform.tfstate"
    region  = "eu-west-1"
    profile = "ri-dev"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "ri-root"

  // only allow terraform to run in this account it
  allowed_account_ids = ["444440085706"]

  assume_role {
    role_arn = "arn:aws:iam::444440085706:role/OrganizationAccountAccessRole"
  }
}

variable "environment" {
  type        = "string"
  description = "the environment of the account"
  default     = "staging"
}

variable "project_name" {
  type        = "string"
  description = "describe your variable"
  default     = "order"
}

data "aws_iam_policy_document" "developer_override_policy_document" {
  /* required perms */
  statement {
    actions = [
      "kms:Encrypt",
      "ds:AuthorizeApplication",
      "ds:CheckAlias",
      "ds:CreateAlias",
      "ds:CreateIdentityPoolDirectory",
      "ds:DeleteDirectory",
      "ds:DescribeDirectories",
      "ds:DescribeTrusts",
      "ds:UnauthorizeApplication",
      "quicksight:CreateUser",
      "quicksight:CreateAdmin",
      "quicksight:Subscribe",
    ]

    resources = [
      "*",
    ]
  }

  /* On call permissions */
  statement {
    actions = [
      "kms:GenerateDataKey",
      "lambda:UpdateFunctionConfiguration",
      "kinesis:PutRecord",
    ]

    resources = [
      "*",
    ]
  }

  /* Manual Athena process permissions */
  statement {
    actions = [
      "athena:RunQuery",
      "athena:StartQueryExecution",
      "athena:StopQueryExecution",
      "athena:CancelQueryExecution",
      "glue:BatchDeletetTable",
      "glue:BatchGetPartition",
      "glue:BatchStopJobRun",
      "glue:CreateDatabase",
      "glue:CreatePartition",
      "glue:CreateTable",
      "glue:ImportCatalogToGlue",
      "glue:UpdateDatabase",
      "glue:UpdateJob",
      "glue:UpdatePartition",
      "glue:UpdateTable",
      "glue:GetDatabase",
      "glue:GetDatabases",
      "glue:GetDataflowGraph",
      "glue:GetJob",
      "glue:GetJobRun",
      "glue:GetJobRuns",
      "glue:GetJobs",
      "glue:GetMapping",
      "glue:GetPartition",
      "glue:GetPartitions",
      "glue:GetTable",
      "glue:GetTables",
      "glue:GetTableVersions",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "s3:ListObjects",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:AbortMultipartUpload",
    ]

    resources = [
      "arn:aws:s3:::order-data-extract-staging",
      "arn:aws:s3:::order-data-extract-staging/*",
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

  aws_iam_root_account_id           = "667800118351"
  aws_product_management_account_id = "710660959603"
}

module "s3_state_bucket" {
  source       = "../../../modules/s3_state_bucket"
  environment  = "${var.environment}"
  project_name = "${var.project_name}"
}

module "cloudtrail_member_account" {
  source = "../../../modules/cloudtrail_member_account"
}
