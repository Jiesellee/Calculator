provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
}

// sets up a single az vpc and a keypair
module "base" {
  source = "../base"

  namespace           = "${var.namespace}"
  module_name         = "concourse-ci"
  jump_box_allowed_ip = "193.105.212.250"
}

data "aws_iam_policy_document" "dummy_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3:::*/*",
    ]
  }
}

module "concourseci" {
  source = "../../concourse_ci"

  project_name                 = "${var.project_name}"
  project_domain               = "io"
  environment                  = "${var.environment}"
  vpc_id                       = "${module.base.vpc_vpc_id}"
  public_subnets               = "${module.base.vpc_public_subnets}"
  private_subnets              = "${module.base.vpc_private_subnets}"
  vpc_subnet                   = "${module.base.vpc_cidr}"
  ec2_key_pair                 = "${module.base.aws_key_pair_key_name}"
  ecs_instance_type            = "${var.ecs_instance_type}"
  postgres_multi_az            = "false"
  postgres_skip_final_snapshot = "true"

  kms_key_arn    = "arn:aws:kms:eu-west-1:460402331925:key/59a9c32a-fb35-4cc4-b856-bb557e37664f"
  encrypted_keys = "${var.encrypted_keys}"

  additional_ecs_instance_role_policy = "${data.aws_iam_policy_document.dummy_policy.json}"

  config_external_url          = "http://localhost"
  config_github_auth_client_id = "d04a2d6be4ff9b2f54e8"

  config_basic_auth_encrypted_password = "AQECAHjl1QBQxYpegulpOE3mwmJVcwCfECJkIBhp1DNlm4QkZgAAAH4wfAYJKoZIhvcNAQcGoG8wbQIBADBoBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDCM/bOgS5uGgp43OMQIBEIA7E6mx6+Hkyi7L5k+pikEMwKwdmey3yGDipGPTnXtPcOcwHw/4f7Gu0Z6JbuF9w9KjKaxDknCVtcBMV7M="
  config_postgres_encrypted_password   = "AQECAHjl1QBQxYpegulpOE3mwmJVcwCfECJkIBhp1DNlm4QkZgAAAH4wfAYJKoZIhvcNAQcGoG8wbQIBADBoBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDMPeYeU2HERlD6tHfwIBEIA7xs1e6kefAVWPsblYCoq51euaS4HD6xQvvU0NHLyDGJCuXqD9mKi0q0gM94DVCjnZFhuptzVl7hgvSoE="
  config_github_auth_client_secret     = "AQECAHjl1QBQxYpegulpOE3mwmJVcwCfECJkIBhp1DNlm4QkZgAAAIcwgYQGCSqGSIb3DQEHBqB3MHUCAQAwcAYJKoZIhvcNAQcBMB4GCWCGSAFlAwQBLjARBAzuYbifOElezoYfKqoCARCAQ2tA5WBDsVTOv9Z6smJ8AYU5uwmWRSDIhn3GH5TWKYyXzWA3DhjQn4YPLC4TcLkrqj9Pkpno4gZcCClTdoxwcSSR2CE="

  web_additional_env_vars = "{\"name\": \"test\", \"value\": \"dayum\"},{\"name\": \"testye\", \"value\": \"dayum1\"}"
  concourse_init_version  = "pull-request"

  concourse_ecs_min_size         = "${var.concourse_ecs_min_size}"
  concourse_ecs_max_size         = "${var.concourse_ecs_max_size}"
  concourse_ecs_desired_capacity = "${var.concourse_ecs_desired_capacity}"
}

output "aws_key_pair_private_key" {
  value = "${module.base.aws_key_pair_private_key}"
}

output "jump_box_ip" {
  value = "${module.base.jump_box_ip}"
}

resource "aws_ecr_repository" "hello_world" {
  name = "${var.project_name}-${var.environment}-hello-world"
}
