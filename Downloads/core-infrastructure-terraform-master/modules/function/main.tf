resource "aws_iam_role" "lambda_default" {
  name = "${var.function_name}_iam_role_${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_default" {
  name = "${var.function_name}_policy_${var.environment}"
  role = "${aws_iam_role.lambda_default.name}"

  policy = "${var.lambda_role_policy}"

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_lambda_function" "function_definition" {
  filename      = "${var.deployment_package_filename}"
  function_name = "${var.function_name}_${var.environment}"

  description = "${var.function_description}"
  handler     = "${var.function_handler}"
  memory_size = "${var.lambda_memory}"
  timeout     = "${var.lambda_timeout}"
  role        = "${aws_iam_role.lambda_default.arn}"
  runtime     = "${var.function_runtime}"
  publish     = "${var.publish_function_versions}"

  environment = {
    variables = "${var.function_environment_variables}"
  }

  vpc_config {
    security_group_ids = ["${var.default_security_group_id}"]
    subnet_ids         = ["${var.private_subnets}"]
  }

  source_code_hash = "${base64sha256(file("${var.deployment_package_filename}"))}"
  depends_on       = ["aws_iam_role_policy.lambda_default"]
}
