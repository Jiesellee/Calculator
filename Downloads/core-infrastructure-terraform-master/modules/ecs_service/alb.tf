resource "aws_alb_listener_rule" "generic" {
  count = "${var.enable_http_listener ? 1 : 0 }"

  listener_arn = "${var.listener_arn}"
  priority     = "${var.priority}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.generic.arn}"
  }

  condition {
    field  = "${var.alb_routing_method}"
    values = ["${var.alb_routing_pattern}"]
  }
}

resource "aws_alb_listener_rule" "ssl" {
  count = "${var.enable_https_listener ? 1 : 0 }"

  listener_arn = "${var.listener_ssl_arn}"
  priority     = "${var.priority}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.generic.arn}"
  }

  condition {
    field  = "${var.alb_routing_method}"
    values = ["${var.alb_routing_pattern}"]
  }
}

resource "aws_alb_target_group" "generic" {
  name = "${var.target_group_hack == "" ? replace(var.service_name, "_","-") : var.target_group_hack}"

  // overriden when registered by ECS
  port                 = "${var.service_port}"
  protocol             = "HTTP"
  deregistration_delay = 5

  health_check {
    interval            = 160
    timeout             = 60
    unhealthy_threshold = 6
    healthy_threshold   = 2
    matcher             = "200"

    path = "${var.health_check_path}"
  }

  vpc_id = "${var.vpc_id}"
}

output "alb_target_group_arn" {
  value = "${aws_alb_target_group.generic.arn}"
}

output "alb_target_group_arn_suffix" {
  value = "${aws_alb_target_group.generic.arn_suffix}"
}
