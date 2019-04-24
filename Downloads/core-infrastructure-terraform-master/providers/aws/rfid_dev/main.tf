terraform {
  backend "s3" {
    bucket  = "dev-core-tf-state"
    key     = "rfid_dev/terraform.tfstate"
    region  = "eu-west-1"
    profile = "ri-dev"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "ri-root"

  // only allow terraform to run in this account it
  allowed_account_ids = ["217777530268"]

  assume_role {
    role_arn = "arn:aws:iam::217777530268:role/OrganizationAccountAccessRole"
  }
}

module "iam_member_account" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/iam_member_account?ref=6edb4acaf3ef0358bef21d71d29e502536df5d7f"

  aws_iam_root_account_id = "667800118351"

  developers_full_access = "true"

  aws_product_management_account_id = "728741135697"
}

module "cloudtrail_member_account" {
  source = "../../../modules/cloudtrail_member_account"
}
