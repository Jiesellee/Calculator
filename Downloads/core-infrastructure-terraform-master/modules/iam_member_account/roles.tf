resource "aws_iam_role" "administrators" {
  name = "administrators${var.test_environment ? "-test" : "" }"

  assume_role_policy = "${data.aws_iam_policy_document.administrators_assume_role_policy.json}"
}

data "aws_iam_policy_document" "administrators_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_iam_root_account_id}:root"]
    }
  }
}

resource "aws_iam_role" "developers" {
  name = "developers${var.test_environment ? "-test" : "" }"

  assume_role_policy = "${data.aws_iam_policy_document.developers_assume_role_policy.json}"
}

data "aws_iam_policy_document" "developers_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_iam_root_account_id}:root"]
    }
  }
}

resource "aws_iam_role" "operations" {
  name = "operations${var.test_environment ? "-test" : "" }"

  assume_role_policy = "${data.aws_iam_policy_document.operations_assume_role_policy.json}"
}

data "aws_iam_policy_document" "operations_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.aws_iam_root_account_id}:root"]
    }
  }
}

resource "aws_iam_role" "continuous_delivery" {
  name = "cd${var.test_environment ? "-test" : "" }"

  assume_role_policy = "${data.aws_iam_policy_document.continuous_delivery_assume_role_policy.json}"
  count              = "${length(compact(list(var.aws_product_management_account_id, var.aws_management_account_id))) == 0 ? 0 : 1}"
}

data "aws_iam_policy_document" "continuous_delivery_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${formatlist("arn:aws:iam::%s:root", compact(list(var.aws_product_management_account_id, var.aws_management_account_id)))}"]
    }
  }

  count = "${length(compact(list(var.aws_product_management_account_id, var.aws_management_account_id))) == 0 ? 0 : 1}"
}

resource "aws_iam_role" "cloudwatch_allow_read" {
  name = "cloudwatch${var.test_environment ? "-test" : "" }"

  assume_role_policy = "${data.aws_iam_policy_document.cloudwatch_assume_role_policy.json}"
  count              = "${length(var.aws_monitoring_account_ids) == 0 ? 0 : 1}"
}

data "aws_iam_policy_document" "cloudwatch_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${formatlist("arn:aws:iam::%s:root", var.aws_monitoring_account_ids)}"]
    }
  }

  count = "${length(var.aws_monitoring_account_ids) == 0 ? 0 : 1}"
}
