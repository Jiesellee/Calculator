provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
  profile             = "ri-root"

  assume_role {
    role_arn = "arn:aws:iam::460402331925:role/OrganizationAccountAccessRole"
  }
}
