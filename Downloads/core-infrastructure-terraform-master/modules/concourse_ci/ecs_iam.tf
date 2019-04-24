//
// ec2 container instance role & policy
//
resource "aws_iam_role" "ecs_ec2_instance" {
  name               = "${var.project_name}-${var.environment}-ecs-instance"
  assume_role_policy = "${file("${path.module}/policies/ec2_instance_role.json")}"
}

resource "aws_iam_role_policy" "ecs_ec2_instance" {
  name   = "${var.project_name}-${var.environment}-ecs-instance"
  policy = "${data.template_file.ecs_ec2_instance_role_policy.rendered}"
  role   = "${aws_iam_role.ecs_ec2_instance.id}"
}

data "template_file" "ecs_ec2_instance_role_policy" {
  template = "${file("${path.module}/policies/ecs_instance_role_policy.json.tpl")}"

  vars {
    environment        = "${var.environment}"
    project_name       = "${var.project_name}"
    versions_s3_bucket = "${aws_s3_bucket.versions.arn}"
  }
}

resource "aws_iam_role_policy" "additional_ecs_ec2_instance" {
  name   = "${var.project_name}-${var.environment}-ecs-instance-additional-policy"
  policy = "${var.additional_ecs_instance_role_policy}"
  role   = "${aws_iam_role.ecs_ec2_instance.id}"

  count = "${var.additional_ecs_instance_role_policy == "false" ? 0 : 1  }"
}

//
// IAM profile to be used in auto-scaling launch configuration
//
resource "aws_iam_instance_profile" "ecs_ec2_instance" {
  name = "${var.project_name}-${var.environment}-ecs-instance"
  path = "/"
  role = "${aws_iam_role.ecs_ec2_instance.name}"
}

// ecs scheduler role & policy
resource "aws_iam_role" "ecs_scheduler" {
  name               = "${var.project_name}-${var.environment}-ecs-scheduler"
  assume_role_policy = "${file("${path.module}/policies/ecs_scheduler_role.json")}"
}

resource "aws_iam_role_policy" "ecs_scheduler_role_policy" {
  name   = "${var.project_name}-${var.environment}-ecs-scheduler"
  policy = "${file("${path.module}/policies/ecs_scheduler_role_policy.json")}"
  role   = "${aws_iam_role.ecs_scheduler.id}"
}

//
// ecs task scheduler role & policy for concourse ci
//
resource "aws_iam_role" "ecs_service" {
  name               = "${var.project_name}-${var.environment}-cci"
  assume_role_policy = "${file("${path.module}/policies/ecs_service_role.json")}"
}

data "template_file" "ecs_service_role_policy" {
  template = "${file("${path.module}/policies/ecs_service_role_policy.json.tpl")}"

  vars {
    kms_key_arn = "${var.kms_key_arn}"
  }
}

// ecs service role
resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "${var.project_name}-${var.environment}-cci"
  policy = "${data.template_file.ecs_service_role_policy.rendered}"
  role   = "${aws_iam_role.ecs_service.id}"
}

resource "aws_iam_role_policy" "additional_ecs_service_role_policy" {
  name   = "${var.project_name}-${var.environment}-cci-additional-policy"
  policy = "${var.additional_ecs_service_role_policy}"
  role   = "${aws_iam_role.ecs_service.id}"

  count = "${var.additional_ecs_service_role_policy == "false" ? 0 : 1 }"
}
