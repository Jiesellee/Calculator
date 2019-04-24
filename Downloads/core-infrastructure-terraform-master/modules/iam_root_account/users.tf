// Create all users.
// TODO: create these in jumpcloud/onelogin and link to aws with a SAML provider
// There is a depends on in the groups.tf on the name of this resource.
resource "aws_iam_user" "users" {
  name          = "${element(var.users, count.index)}"
  count         = "${length(var.users)}"
  force_destroy = true
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}

// create one time password and encrypt it using the pgp key assigned in the var.users_pgp_keys map
resource "aws_iam_user_login_profile" "users" {
  user = "${element(aws_iam_user.users.*.name, count.index)}"

  // if theres no pgp key in the list, return empty string and dont bother creating a encrypted password
  pgp_key = "${lookup(var.users_pgp_keys, element(aws_iam_user.users.*.name, count.index))}"
  count   = "${length(var.users)}"
}

data "aws_caller_identity" "current" {}

data "template_file" "base_policy" {
  template = "${file("${path.module}/policies/base_policy.json.tpl")}"

  vars {
    account_id = "${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_iam_user_policy" "base" {
  name   = "base-policy"
  user   = "${element(aws_iam_user.users.*.name, count.index)}"
  policy = "${data.template_file.base_policy.rendered}"

  count = "${length(var.users)}"
}
