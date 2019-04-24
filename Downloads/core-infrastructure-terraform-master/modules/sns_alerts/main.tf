resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alert-topic"
}

resource "aws_sns_topic_policy" "alerts" {
  arn    = "${aws_sns_topic.alerts.arn}"
  policy = "${data.aws_iam_policy_document.alerts.json}"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "alerts" {
  statement {
    sid    = "1"
    effect = "Allow"

    actions = [
      "sns:GetTopicAttributes",
      "sns:Publish",
    ]

    resources = ["${aws_sns_topic.alerts.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceOwner"
      values   = ["${data.aws_caller_identity.current.account_id}"]
    }
  }

  statement {
    sid       = "2"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = ["${aws_sns_topic.alerts.arn}"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }

  statement {
    sid       = "3"
    effect    = "Allow"
    actions   = ["sns:GetTopicAttributes", "sns:Publish"]
    resources = ["${aws_sns_topic.alerts.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudwatch:eu-west-1:${data.aws_caller_identity.current.account_id}:alarm:*"]
    }
  }
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = "${aws_sns_topic.alerts.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.slack_alerts.arn}"
}

data "template_file" "lambda_config" {
  template = "${file("${path.module}/templates/config.json.tpl")}"

  vars {
    encrypted_webhook_url = "${var.encrypted_slack_webhook_url}"
    channel_map           = "${jsonencode(var.sns_to_slack_channel_mapping)}"
  }
}

resource "aws_iam_role" "lambda_default" {
  name = "sns_to_slack_alerts_iam_role_${var.environment}"

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
  name = "sns_to_slack_alerts_policy_${var.environment}"
  role = "${aws_iam_role.lambda_default.name}"

  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Effect": "Allow",
    "Action": [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ],
    "Resource": "*"
  },
  {
    "Effect": "Allow",
    "Action": [
      "kms:Decrypt",
      "kms:DescribeKey"
    ],
    "Resource": "${var.kms_key_alias_arn}"
  }
]
}
EOF

  // there is a delay in this policy becoming available so a hacky sleep is needed.
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_lambda_function" "slack_alerts" {
  function_name = "sns_to_slack_alerts_${var.environment}"

  description = "send sns alerts to slack"
  handler     = "lambda_function.lambda_handler"
  memory_size = "128"
  timeout     = "10"
  role        = "${aws_iam_role.lambda_default.arn}"
  runtime     = "python2.7"

  environment = {
    variables = {
      LAMBDA_CONFIG = "${data.template_file.lambda_config.rendered}"
    }
  }

  vpc_config {
    security_group_ids = ["${var.security_group}"]
    subnet_ids         = ["${var.private_subnets}"]
  }

  s3_bucket = "prod-core-shared-assets"
  s3_key    = "aws-lambda-sns-to-slack/aws-lambda-sns-to-slack.zip"

  source_code_hash = "${var.slack_lambda_zip_shasum}"
  depends_on       = ["aws_iam_role_policy.lambda_default"]
}

resource "aws_lambda_permission" "allow_sns_to_call_slack_alerts" {
  statement_id  = "AllowExecutionFromSNSToSlackAlerts"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.slack_alerts.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.alerts.arn}"
  depends_on    = ["aws_lambda_function.slack_alerts", "aws_sns_topic.alerts"]
}
