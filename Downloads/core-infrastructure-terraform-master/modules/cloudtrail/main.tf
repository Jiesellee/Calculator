resource "aws_cloudtrail" "default" {
  name                          = "monitoring-account"
  s3_bucket_name                = "${aws_s3_bucket.default.id}"
  include_global_service_events = false
}

resource "aws_s3_bucket" "default" {
  bucket        = "${var.s3_bucket_name}"
  force_destroy = true

  policy = "${data.aws_iam_policy_document.s3_bucket_policy.json}"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
    ]

    principals = {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]

    principals = {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
    ]

    principals = {
      type        = "AWS"
      identifiers = ["${formatlist("arn:aws:iam::%s:root", compact(concat(var.aws_accounts, list(data.aws_caller_identity.current.account_id))))}"]
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]

    principals = {
      type        = "AWS"
      identifiers = ["${formatlist("arn:aws:iam::%s:root", compact(concat(var.aws_accounts, list(data.aws_caller_identity.current.account_id))))}"]
    }
  }
}
