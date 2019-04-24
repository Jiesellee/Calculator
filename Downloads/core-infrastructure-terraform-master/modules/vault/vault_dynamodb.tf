resource "aws_dynamodb_table" "vault-table" {
  name           = "${local.prefix}-vault-table"
  read_capacity  = "${var.dynamodb_read_capacity}"
  write_capacity = "${var.dynamodb_write_capacity}"
  hash_key       = "Path"
  range_key      = "Key"

  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }

  tags {
    Name         = "${local.prefix}-vault-table"
    environment  = "${var.environment}"
    project_name = "${var.project_name}"
  }
}

// IAM role for dynamodb
resource "aws_iam_role" "vault_dynamodb_role" {
  name               = "${local.prefix}-vault-dynamodb"
  assume_role_policy = "${file("${path.module}/policies/dynamodb_role_assume.json")}"
}

// IAM policy for dynamodb
resource "aws_iam_role_policy" "vault_dynamodb_policy" {
  name   = "${local.prefix}-vault-dynamodb"
  policy = "${data.template_file.vault_dynamodb_policy_tpl.rendered}"
  role   = "${aws_iam_role.vault_dynamodb_role.id}"
}

data "template_file" "vault_dynamodb_policy_tpl" {
  template = "${file("${path.module}/policies/dynamodb_role_policy.json.tpl")}"

  vars {
    environment  = "${var.environment}"
    project_name = "${var.project_name}"
    region       = "${var.region}"
  }
}
