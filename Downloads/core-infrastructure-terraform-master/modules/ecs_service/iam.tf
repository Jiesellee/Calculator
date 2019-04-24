/* ecs iam role and policies */
resource "aws_iam_role" "ecs_service" {
  name               = "${var.project_name}-${var.environment}-${var.service_name}"
  assume_role_policy = "${file("${path.module}/iam_policies/ecs_service_assume_role_policy.json")}"
}

/* ecs service role */
resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "${var.project_name}-${var.environment}-ecs-service"
  policy = "${file("${path.module}/iam_policies/ecs_service_role_policy.json")}"
  role   = "${aws_iam_role.ecs_service.id}"
}

/* ecs task role */
data "aws_iam_policy_document" "task_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "task_role" {
  name = "${var.service_name}_${var.environment}_task_role"

  assume_role_policy = "${data.aws_iam_policy_document.task_role.json}"
}

resource "aws_iam_role_policy_attachment" "task_role_policy_attachements" {
  count = "${var.task_policy == "false" ? 0 : 1}"

  role       = "${aws_iam_role.task_role.name}"
  policy_arn = "${var.task_policy_arn}"
}
