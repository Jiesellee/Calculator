variable "ecr_image_tag" {
  description = "version of the container"
}

variable "ecr_image" {
  description = "ecr registry address in the format of ${ACCOUNT_ID}.dkr.ecr.eu-west-1.amazonaws.com/${REPO_NAME}"
}

variable "service_name" {
  type        = "string"
  description = "the name of the service"
}

variable "db_name" {
  type        = "string"
  description = "database name"
}

variable "db_username" {
  type        = "string"
  description = "database username"
}

variable "db_password" {
  type        = "string"
  description = "database password"
}

variable "db_url" {
  type        = "string"
  description = "database url"
}

variable "override_flyway_command" {
  type        = "string"
  description = "override flyway_command"
  default     = " "
}

locals {
  log_group_name = "${var.service_name}-db-migration"

  flyway_command = "${var.override_flyway_command != " " ? var.override_flyway_command :
                      "migrate -locations=filesystem:sql -url=jdbc:postgresql://${var.db_url}/${var.db_name} -user=${var.db_username} -password=${var.db_password}"
                    }"
}

data "template_file" "ecs_task_definition" {
  template = "${file("${path.module}/task_definition.json.tpl")}"

  vars {
    service_name   = "${var.service_name}"
    ecr_image_tag  = "${var.ecr_image_tag}"
    ecr_image      = "${var.ecr_image}"
    flyway_command = "${jsonencode(split(" ", local.flyway_command))}"
    log_group_name = "${local.log_group_name}"
  }
}

resource "aws_ecs_task_definition" "default" {
  family                = "${var.service_name}-db-migration"
  container_definitions = "${data.template_file.ecs_task_definition.rendered}"
}

resource "aws_cloudwatch_log_group" "default" {
  name = "${local.log_group_name}"

  tags {
    service_name = "${var.service_name}"
  }
}

// I don't really like this but it works and its ok for now!
// write the file to the root module
resource "local_file" "deploy_script" {
  content  = "${file("${path.module}/deploy_script.sh")}"
  filename = "${path.root}/deploy_script.sh"
}

output "aws_ecs_task_definition_name" {
  value = "${aws_ecs_task_definition.default.family}"
}
