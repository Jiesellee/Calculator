provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
}

module "iam_member_account" {
  source                 = "../../iam_member_account"
  developers_full_access = "true"
  test_environment       = "true"
}
