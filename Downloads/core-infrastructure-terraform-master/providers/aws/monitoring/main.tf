terraform {
  backend "s3" {
    bucket  = "dev-core-tf-state"
    key     = "monitoring/terraform.tfstate"
    region  = "eu-west-1"
    profile = "ri-dev"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "ri-root"

  allowed_account_ids = ["627505981536"]

  assume_role {
    role_arn = "arn:aws:iam::627505981536:role/OrganizationAccountAccessRole"
  }
}

module "cloudtrail" {
  source = "../../../modules/cloudtrail"

  # eventually we should pull these from a remote state output of the root account where aws organisations is managed.
  # we cant do this yet as aws organisations is not fully feature complete and terraform doesent support it yet either.
  aws_accounts = [
    "548502469463",
    "667800118351",
    "556748783639",
    "168416847939",
    "002540887416",
    "350793678069",
    "666469064441",
    "338727929577",
    "204403389885",
    "728741135697",
    "217777530268",
    "575393571653",
    "215821541440",
    "376076567968",
    "627505981536",
    "710660959603",
    "677677631524",
    "444440085706",
    "978203441460",
    "285065638507",
    "460402331925",
  ]
}

module "iam_member_account" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/iam_member_account?ref=6edb4acaf3ef0358bef21d71d29e502536df5d7f"

  aws_iam_root_account_id = "667800118351"
}
