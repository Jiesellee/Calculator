resource "aws_alb" "default" {
  name            = "${var.project_name}-${var.environment}-ecs-${var.instance_id}"
  internal        = true
  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["${var.private_subnets}"]

  tags {
    Name        = "${var.project_name}-${var.environment}-ecs-default"
    created-by  = "terraform"
    environment = "${var.environment}"
    project     = "${var.project_name}"
  }
}

// this should redirect to HTTPS
resource "aws_alb_listener" "default_http" {
  load_balancer_arn = "${aws_alb.default.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}

// optional https listener 
resource "aws_alb_listener" "default_https" {
  count = "${var.enable_elb_ssl ? 1 : 0 }"

  load_balancer_arn = "${aws_alb.default.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "${var.ssl_policy}"
  certificate_arn   = "${var.ssl_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}

// this is the default target group and serves the root endpoint
resource "aws_alb_target_group" "default" {
  name                 = "${var.project_name}-${var.environment}-default"
  port                 = 8080
  protocol             = "HTTP"
  deregistration_delay = 5
  vpc_id               = "${var.vpc_id}"

  health_check {
    interval            = 80
    timeout             = 40
    unhealthy_threshold = 3
    healthy_threshold   = 2
    path                = "/"
    matcher             = "200"
  }

  // this is to create the new default target group used by the default group before deleting it?
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-ecs-alb-${var.instance_id}"
  description = "Security group allowing traffic to the ALB"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.project_name}-${var.environment}-elb-ecs-${var.instance_id}"
    Created-by  = "terraform"
    Environment = "${var.environment}"
    project     = "${var.project_name}"
  }

  // we are using the ephemeral port range for containers
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = "${var.alb_allowed_cidr_blocks}"
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = "${var.alb_allowed_cidr_blocks}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
