// Create A VPC with multi AZ private and public subnets
module "vpc" {
  // Use the comminity VPC module with a pinned revision number
  source          = "git::https://github.com/terraform-community-modules/tf_aws_vpc.git?ref=c51d8a37e6a07c6b82926351c4ca01ea624ced28"
  name            = "${var.project_name}-${var.module_instance_id}"
  cidr            = "${var.vpc_cidr}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"
  azs             = ["eu-west-1a", "eu-west-1b"]

  // enable nat gateway
  enable_nat_gateway = "true"

  // This sets the search domain in DHCP options
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    "Name"         = "${var.environment}-${var.project_name}-${var.module_instance_id}"
    "terraform"    = "true"
    "environment"  = "${var.environment}"
    "project_name" = "${var.project_name}"
  }
}

resource "aws_key_pair" "default" {
  key_name   = "${var.project_name}-${var.environment}-default"
  public_key = "${file("${path.root}/${var.aws_ssh_key_file}.pub")}"
}

resource "aws_route53_zone" "management" {
  name = "${var.environment}.management.ri-tech.io."

  tags {
    "terraform"    = "true"
    "environment"  = "${var.environment}"
    "project_name" = "${var.project_name}"
    "cost_center"  = "81184"
  }
}

module "jump_box" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/jump_box?ref=3f0fa44be8867b4926daa3b7db40d01b25b5e6e0"

  project_name = "${var.project_name}"
  environment  = "${var.environment}"
  vpc_id       = "${module.vpc.vpc_id}"
  ssh_key_name = "${aws_key_pair.default.key_name}"
  subnet       = "${element(module.vpc.public_subnets, 0)}"
  public       = "true"

  // office ip
  jump_box_allowed_range        = "193.105.212.250/32"
  jump_box_allowed_range_enable = "true"
}

resource "aws_route53_record" "jump_box" {
  zone_id = "${aws_route53_zone.management.zone_id}"
  name    = "jump"
  type    = "A"
  ttl     = "60"
  records = ["${module.jump_box.ip_address}"]
}

// this state bucket is used by all 'core' AWS accounts. These accounts only have one environment and this is production
module "s3_state_management" {
  source       = "../s3_state_bucket"
  environment  = "management"
  project_name = "admin"
}

resource "aws_ecr_repository" "eawsy_shim" {
  name = "eawsy-go-shim"
}

resource "aws_ecr_repository_policy" "eawsy_shim" {
  repository = "${aws_ecr_repository.eawsy_shim.name}"

  policy = "${data.aws_iam_policy_document.ecr_repository_concourse_ci.json}"
}

resource "aws_ecr_repository" "concourse_ci" {
  name = "concourse-ci"
}

resource "aws_ecr_repository_policy" "concourse_ci" {
  repository = "${aws_ecr_repository.concourse_ci.name}"

  policy = "${data.aws_iam_policy_document.ecr_repository_concourse_ci.json}"
}

data "aws_caller_identity" "current" {}

// allow accounts read only access
data "aws_iam_policy_document" "ecr_repository_concourse_ci" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
    ]

    principals = {
      type        = "AWS"
      identifiers = ["${formatlist("arn:aws:iam::%s:root", compact(var.ecr_repo_concourse_ci_allowed_aws_accounts_ro))}"]
    }
  }
}

// This holds things that we cannot easily fetch from an external source, e.g ords.
// Only store binaries in this bucket, not config or anything that cant be public.
// the state bucket module should really just be a s3 bucket module.
module "s3_shared_assets" {
  source         = "../s3_state_bucket"
  environment    = "prod"
  project_name   = "core"
  bucket_purpose = "shared-assets"
}

output "s3_shared_assets_bucket_name" {
  value = "${module.s3_shared_assets.bucket_name}"
}
