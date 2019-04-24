terraform {
  backend "s3" {
    bucket  = "dev-core-tf-state"
    key     = "root/terraform.tfstate"
    region  = "eu-west-1"
    profile = "ri-dev"
  }
}

provider "aws" {
  # this is the test account id
  allowed_account_ids = ["548502469463"]
  region              = "eu-west-1"
  profile             = "ri-root"
}

module "iam_member_account" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/iam_member_account?ref=6f619a1601e2a0c1ef70611227d3b66ef9b4b83d"

  aws_iam_root_account_id = "667800118351"
}

module "cloudtrail_member_account" {
  source = "../../../modules/cloudtrail_member_account"
}
