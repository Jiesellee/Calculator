#format("%s-%s", var.bucket_purpose, \"state\")

module "vaultguard_bucket" {
  source           = "../../modules/s3_state_bucket"
  environment      = "${var.environment}"
  project_name     = "${var.project_name}"
  namespace_prefix = "${var.namespace}"
  bucket_purpose   = "${local.bucket_purpose_suffix}"
}
