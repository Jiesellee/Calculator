// create iam groups
resource "aws_iam_group" "administrators" {
  name = "${var.project_name}-administrators"
}

// assign users membership to groups
resource "aws_iam_group_membership" "administrators" {
  name = "${var.project_name}-administrator-access-group"

  users = [
    "${var.administrator_group_membership}",
  ]

  group = "${aws_iam_group.administrators.name}"
}

resource "aws_iam_group_policy" "administrators" {
  name  = "${var.project_name}-administrators-access-group"
  group = "${aws_iam_group.administrators.id}"

  policy = "${data.aws_iam_policy_document.administrators_assume_role_policy.json}"
}

data "aws_iam_policy_document" "administrators_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = "${formatlist("arn:aws:iam::%s:role/administrators", values(var.aws_account_ids))}"
  }
}

resource "aws_iam_group" "developers" {
  name = "${var.project_name}-developers"
}

resource "aws_iam_group_membership" "developers" {
  name = "${var.project_name}-developer-access-group"

  users = [
    "${var.developer_group_membership}",
  ]

  group = "${aws_iam_group.developers.name}"
}

resource "aws_iam_group_policy" "developers" {
  name  = "${var.project_name}-developers-access-group"
  group = "${aws_iam_group.developers.id}"

  policy = "${data.aws_iam_policy_document.developers_assume_role_policy.json}"
}

data "aws_iam_policy_document" "developers_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = "${formatlist("arn:aws:iam::%s:role/developers", values(var.aws_account_ids))}"
  }
}

// create iam group for operations
resource "aws_iam_group" "operations" {
  name = "${var.project_name}-operations"
}

// assign users membership to groups
resource "aws_iam_group_membership" "operations" {
  name = "${var.project_name}-administrator-access-group"

  users = [
    "${var.operations_group_membership}",
  ]

  group = "${aws_iam_group.operations.name}"
}

resource "aws_iam_group_policy" "operations" {
  name  = "${var.project_name}-operations-access-group"
  group = "${aws_iam_group.operations.id}"

  policy = "${data.aws_iam_policy_document.operations_assume_role_policy.json}"
}

data "aws_iam_policy_document" "operations_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = "${formatlist("arn:aws:iam::%s:role/operations", values(var.aws_account_ids))}"
  }
}
