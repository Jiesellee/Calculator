provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
}

module "iam_root_account" {
  source = "../../iam_root_account"

  users = [
    "willejs",
  ]

  users_pgp_keys = {
    willejs = "keybase:willejs"
  }

  developers = ["willejs"]

  administrators = ["willejs"]
}

output "aws_iam_users_encrypted_passwords" {
  value = "${module.iam_root_account.aws_iam_users_encrypted_passwords}"
}
