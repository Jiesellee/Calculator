module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.3.0"

  name = "${var.namespace}test"

  cidr                = "10.${var.cidr_namespace}.0.0/16"
  private_subnets     = ["10.${var.cidr_namespace}.1.0/24", "10.${var.cidr_namespace}.2.0/24"]
  private_subnet_tags = "${var.private_subnet_tags}"

  public_subnets     = ["10.${var.cidr_namespace}.3.0/24", "10.${var.cidr_namespace}.4.0/24"]
  public_subnet_tags = "${var.public_subnet_tags}"

  enable_nat_gateway = "true"
  enable_dns_support = "true"

  azs = ["eu-west-1a", "eu-west-1b"]

  tags {
    "Terraform"   = "true"
    "Environment" = "test"
    "Name"        = "test-infra"
  }
}

resource "aws_route53_zone" "default" {
  name = "test.ri-tech.io"
}
