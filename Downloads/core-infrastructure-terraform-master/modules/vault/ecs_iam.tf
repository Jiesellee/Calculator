//
// ec2 container instance role & policy
//
resource "aws_iam_role" "ecs_ec2_instance" {
  name               = "${local.prefix}-vault-ecs-instance"
  assume_role_policy = "${file("${path.module}/policies/ec2_instance_role.json")}"
}

resource "aws_iam_role_policy" "ecs_ec2_instance" {
  name   = "${local.prefix}-vault-ecs-instance"
  policy = "${data.template_file.ecs_ec2_instance_role_policy.rendered}"
  role   = "${aws_iam_role.ecs_ec2_instance.id}"
}

data "template_file" "ecs_ec2_instance_role_policy" {
  template = "${file("${path.module}/policies/ecs_instance_role_policy.json.tpl")}"

  vars {
    environment    = "${var.environment}"
    project_name   = "${var.project_name}"
    region         = "${var.region}"
    dynamodb_table = "${local.prefix_dynamodb_table_vault}"
  }
}

resource "aws_iam_role_policy" "additional_ecs_ec2_instance" {
  name   = "${local.prefix}-vault-ecs-instance-additional-policy"
  policy = "${var.additional_ecs_instance_role_policy}"
  role   = "${aws_iam_role.ecs_ec2_instance.id}"

  count = "${var.additional_ecs_instance_role_policy == "false" ? 0 : 1  }"
}

//
// IAM profile to be used in auto-scaling launch configuration
//
resource "aws_iam_instance_profile" "ecs_ec2_instance" {
  name = "${local.prefix}-vault-ecs-instance"
  path = "/"
  role = "${aws_iam_role.ecs_ec2_instance.name}"
}

// ecs scheduler role & policy
resource "aws_iam_role" "ecs_scheduler" {
  name               = "${local.prefix}-vault-ecs-scheduler"
  assume_role_policy = "${file("${path.module}/policies/ecs_scheduler_role.json")}"
}

resource "aws_iam_role_policy" "ecs_scheduler_role_policy" {
  name   = "${local.prefix}-vault-ecs-scheduler"
  policy = "${file("${path.module}/policies/ecs_scheduler_role_policy.json")}"
  role   = "${aws_iam_role.ecs_scheduler.id}"
}

//
// ecs task scheduler role & policy for vault
//
resource "aws_iam_role" "ecs_service" {
  name               = "${local.prefix}-vault-ecs-svc"
  assume_role_policy = "${file("${path.module}/policies/ecs_service_role.json")}"
}

// ecs service role
resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "${local.prefix}-vault"
  policy = "${data.template_file.ecs_service_role_policy.rendered}"
  role   = "${aws_iam_role.ecs_service.id}"
}

data "template_file" "ecs_service_role_policy" {
  template = "${file("${path.module}/policies/ecs_service_role_policy.json.tpl")}"

  vars {
    environment  = "${var.environment}"
    project_name = "${var.project_name}"
    region       = "${var.region}"
    kms_key_arn  = "${var.kms_key_arn}"
  }
}

resource "aws_iam_role_policy" "additional_ecs_service_role_policy" {
  name   = "${local.prefix}-vault-additional-policy"
  policy = "${var.additional_ecs_service_role_policy}"
  role   = "${aws_iam_role.ecs_service.id}"

  count = "${var.additional_ecs_service_role_policy == "false" ? 0 : 1 }"
}

//
// ecs task scheduler role & policy for vaultguard
//
resource "aws_iam_role" "ecs_service_vaultguard" {
  name               = "${local.prefix}-vaultguard-ecs-svc"
  assume_role_policy = "${file("${path.module}/policies/ecs_service_role_vaultguard.json")}"

  count = "${var.enable_vaultguard ? 1 : 0}"
}

// ecs service role
resource "aws_iam_role_policy" "ecs_service_role_policy_vaultguard" {
  name   = "${local.prefix}-vaultguard"
  policy = "${data.template_file.ecs_service_role_policy_vaultguard.rendered}"
  role   = "${aws_iam_role.ecs_service_vaultguard.id}"

  count = "${var.enable_vaultguard ? 1 : 0}"
}

data "template_file" "ecs_service_role_policy_vaultguard" {
  template = "${file("${path.module}/policies/ecs_service_role_policy_vaultguard.json.tpl")}"

  vars {
    environment  = "${var.environment}"
    project_name = "${var.project_name}"
    region       = "${var.region}"
    kms_key_arn  = "${var.kms_key_arn}"
  }

  count = "${var.enable_vaultguard ? 1 : 0}"
}
