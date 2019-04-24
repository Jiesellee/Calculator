provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
}

module "iam_root_member_account" {
  source = "../../iam_root_member_account"

  project_name = "test"

  aws_account_ids = {
    test = "460402331925"
  }
}

output "enactor_switch_role_links" {
  value = "${module.iam_root_member_account.iam_switch_role_links}"
}
