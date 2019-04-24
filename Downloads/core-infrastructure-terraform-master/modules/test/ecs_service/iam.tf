data "aws_iam_policy_document" "default" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "default" {
  policy = "${data.aws_iam_policy_document.default.json}"
}
