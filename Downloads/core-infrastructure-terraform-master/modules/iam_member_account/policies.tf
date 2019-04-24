// allow all policy for administrators, or override
resource "aws_iam_policy" "base" {
  name   = "base${var.test_environment ? "-test" : "" }"
  policy = "${data.aws_iam_policy_document.base.json}"
}

// base policy for all roles.
data "aws_iam_policy_document" "base" {
  statement {
    effect = "Allow"

    actions = [
      "support:*",
      "aws-portal:View*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "acm:RequestCertificate",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy_attachment" "base" {
  name = "base"

  roles = [
    "${aws_iam_role.administrators.name}",
    "${aws_iam_role.developers.name}",
    "${aws_iam_role.operations.name}",
  ]

  policy_arn = "${aws_iam_policy.base.arn}"
}

// allow all policy for administrators, or override
resource "aws_iam_policy" "allow_all" {
  name   = "allow_all${var.test_environment ? "-test" : "" }"
  policy = "${data.aws_iam_policy_document.allow_all.json}"
}

// we must use a custom policy as the canned polices are used by the aws OrganizationAccountAccessRole which we need to use for now. 
data "aws_iam_policy_document" "allow_all" {
  statement {
    effect = "Allow"

    actions = [
      "*",
    ]

    resources = [
      "*",
    ]
  }
}

// default policiy for administrators
resource "aws_iam_policy_attachment" "administartor_access" {
  name = "administrator-access"

  roles = [
    "${compact(list(
        aws_iam_role.administrators.name,
        "${var.developers_full_access ? aws_iam_role.developers.name : "" }",
        "${var.operations_full_access ? aws_iam_role.operations.name : "" }" 
      ))}",
  ]

  policy_arn = "${var.override_administrator_policy == "false" ? aws_iam_policy.allow_all.arn : var.override_administrator_policy_arn}"
}

// default policy for developers
resource "aws_iam_policy_attachment" "read_only_access" {
  name = "read-only-access"

  roles = [
    "${compact(list(
        "${var.developers_full_access == "false" ? aws_iam_role.developers.name : "" }",
        "${var.operations_full_access == "false" ? aws_iam_role.operations.name : "" }" 
      ))}",
  ]

  policy_arn = "${var.override_read_only_policy == "false" ? "arn:aws:iam::aws:policy/ReadOnlyAccess" : var.override_read_only_policy_arn}"
}

// custom policy attachment for roles
resource "aws_iam_policy_attachment" "developers" {
  name = "developers"

  roles = [
    "${aws_iam_role.developers.name}",
  ]

  policy_arn = "${var.override_developer_role_policy_arn}"
  count      = "${var.override_developer_role_policy == "false" ? 0 : 1 }"
}

resource "aws_iam_policy_attachment" "administrators" {
  name = "administrators"

  roles = [
    "${aws_iam_role.administrators.name}",
  ]

  policy_arn = "${var.override_administrator_role_policy_arn}"
  count      = "${var.override_administrator_role_policy == "false" ? 0 : 1 }"
}

resource "aws_iam_policy_attachment" "operations" {
  name = "operations"

  roles = [
    "${aws_iam_role.operations.name}",
  ]

  policy_arn = "${var.override_operations_role_policy_arn}"
  count      = "${var.override_operations_role_policy == "false" ? 0 : 1 }"
}

resource "aws_iam_policy" "continuous_delivery" {
  name   = "continuous_delivery${var.test_environment ? "-test" : "" }"
  policy = "${data.aws_iam_policy_document.allow_all.json}"

  count = "${var.aws_product_management_account_id == "false" ? 0 : 1 }"
}

resource "aws_iam_policy_attachment" "continuous_delivery" {
  name = "continuous-delivery"

  roles = ["${aws_iam_role.continuous_delivery.name}"]

  policy_arn = "${aws_iam_policy.continuous_delivery.arn}"

  count = "${length(compact(list(var.aws_product_management_account_id, var.aws_management_account_id))) == 0 ? 0 : 1}"
}

// allow access to all cloudwatch data
resource "aws_iam_policy" "cloudwatch_allow_read" {
  name   = "cloudwatch_allow_read${var.test_environment ? "-test" : "" }"
  policy = "${data.aws_iam_policy_document.cloudwatch_allow_read.json}"
  count  = "${length(var.aws_monitoring_account_ids) == 0 ? 0 : 1}"
}

// we must use a custom policy as the canned polices are used by the aws OrganizationAccountAccessRole which we need to use for now. 
data "aws_iam_policy_document" "cloudwatch_allow_read" {
  statement {
    effect = "Allow"

    actions = [
      "autoscaling:Describe*",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "logs:Get*",
      "logs:Describe*",
      "sns:Get*",
      "sns:List*",
      "aws-portal:View*",
    ]

    resources = [
      "*",
    ]
  }

  count = "${length(var.aws_monitoring_account_ids) == 0 ? 0 : 1}"
}

// default policiy for administrators
resource "aws_iam_policy_attachment" "cloudwatch_allow_read" {
  name = "administrator-access"

  roles = [
    "${aws_iam_role.cloudwatch_allow_read.name}",
  ]

  policy_arn = "${aws_iam_policy.cloudwatch_allow_read.arn}"

  count = "${length(var.aws_monitoring_account_ids) == 0 ? 0 : 1}"
}
