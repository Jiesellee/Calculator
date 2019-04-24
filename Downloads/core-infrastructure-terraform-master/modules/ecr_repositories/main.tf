resource "aws_ecr_repository" "repository" {
  count = "${length(var.repository_names)}"
  name  = "${element(var.repository_names, count.index)}"
}

resource "aws_ecr_repository_policy" "policy" {
  repository = "${element(aws_ecr_repository.repository.*.name, count.index)}"
  count      = "${length(aws_ecr_repository.repository.*.name)}"

  policy = "${data.aws_iam_policy_document.ecr_policy.json}"
}

data "aws_iam_policy_document" "ecr_policy" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${formatlist("arn:aws:iam::%s:root", var.allowed_account_ids)}"]
    }
  }
}
