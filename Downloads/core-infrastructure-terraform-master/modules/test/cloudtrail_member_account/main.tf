provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
}

module "cloudtrail" {
  source = "../../cloudtrail"

  s3_bucket_name = "test-ri-monitoring-cloudtrail"
}

module "cloudtrail_member_account" {
  source = "../../cloudtrail_member_account"

  s3_bucket_name = "${module.cloudtrail.s3_bucket_name}"
}
