resource "aws_sns_topic" "alerts" {
  count = "${length(var.sns_topic_names)}"

  name = "${var.project_name}-${element(var.sns_topic_names, count.index)}-alert-topic"
}

resource "aws_sns_topic_policy" "alerts" {
  count = "${length(var.sns_topic_names)}"

  arn    = "${element(aws_sns_topic.alerts.*.arn, count.index)}"
  policy = "${element(data.aws_iam_policy_document.alerts.*.json, count.index)}"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "alerts" {
  count = "${length(var.sns_topic_names)}"

  statement {
    sid    = "1"
    effect = "Allow"

    actions = [
      "sns:GetTopicAttributes",
      "sns:Publish",
    ]

    resources = ["${element(aws_sns_topic.alerts.*.arn, count.index)}"]

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
    resources = ["${element(aws_sns_topic.alerts.*.arn, count.index)}"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}
