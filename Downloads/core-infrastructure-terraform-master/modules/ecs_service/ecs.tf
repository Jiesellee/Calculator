resource "aws_ecs_service" "default" {
  name            = "${var.service_name}"
  cluster         = "${var.aws_ecs_cluster_arn}"
  task_definition = "${aws_ecs_task_definition.default.arn}"
  desired_count   = "${var.ecs_service_desired_task_count}"

  // not sure this works 
  iam_role = "${aws_iam_role.ecs_service.arn}"

  // don't roll out multiple versions at once
  deployment_maximum_percent = "${var.ecs_service_deployment_maximum_percent}"

  // make sure a task is always active to avoid downtime.
  deployment_minimum_healthy_percent = "${var.ecs_service_deployment_minimum_healthy_percent}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.generic.arn}"
    container_name   = "${var.service_name}"
    container_port   = "${var.service_port}"
  }

  depends_on = ["aws_alb_listener_rule.generic", "aws_alb_listener_rule.ssl"]
}

resource "aws_ecs_task_definition" "default" {
  family                = "${var.service_name}"
  container_definitions = "${var.ecs_task_definition}"

  task_role_arn = "${aws_iam_role.task_role.arn}"

  // mount the efs volume in all containers for now. :(
  volume {
    name      = "efs"
    host_path = "${var.efs_host_path}"
  }
}

resource "aws_route53_record" "ecs_cluster" {
  zone_id = "${var.zone_id}"
  name    = "${var.service_name}-alb"
  type    = "CNAME"
  ttl     = "60"
  records = ["${var.alb_dns_name}"]
}
