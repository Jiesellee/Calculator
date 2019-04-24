provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
}

module "ecr_repositories" {
  source = "../../ecr_repositories"

  repository_names    = ["app1", "app2"]
  allowed_account_ids = ["460402331925"]
}
