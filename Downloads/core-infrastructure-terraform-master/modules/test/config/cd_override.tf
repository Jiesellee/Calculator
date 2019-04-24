provider "aws" {
  version = "= 1.6.0"

  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"

  assume_role {
    role_arn = "arn:aws:iam::460402331925:role/cd"
  }
}
