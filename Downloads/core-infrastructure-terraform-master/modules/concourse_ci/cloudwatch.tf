resource "aws_cloudwatch_log_group" "concourse" {
  name = "concourse-${var.project_name}-${var.environment}"

  tags {
    environment = "${var.environment}"
  }
}
