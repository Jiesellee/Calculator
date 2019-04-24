module "base" {
  source = "../base"

  namespace   = "${var.project_name}"
  module_name = "${var.project_name}"
}

variable "project_name" {
  type    = "string"
  default = "lambda-function"
}

module "lambda_function" {
  source                      = "../../function"
  vpc_id                      = "${module.base.vpc_vpc_id}"
  environment                 = "test"
  function_name               = "my-test-lambda-function"
  deployment_package_filename = "sample.zip"
  private_subnets             = "${module.base.vpc_public_subnets}"
  lambda_role_policy          = "${data.aws_iam_policy_document.base_lambda.json}"
  default_security_group_id   = "${aws_security_group.lambda.id}"
  function_description        = "My test function doesn't do anything"

  function_environment_variables = {
    REGION = "TEST_ENV"
  }
}

data "aws_iam_policy_document" "base_lambda" {
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_security_group" "lambda" {
  name   = "default_lambda"
  vpc_id = "${module.base.vpc_vpc_id}"
}
