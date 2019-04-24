/* ecs service cluster */
resource "aws_ecs_cluster" "vault" {
  name = "${local.prefix}-vault-ecs"
}

// launch config
resource "aws_launch_configuration" "vault_ecs" {
  image_id = "${var.aws_asg_image_id}"

  instance_type        = "${var.ecs_instance_type}"
  key_name             = "${var.ec2_key_pair}"
  security_groups      = ["${aws_security_group.vault_asg_ecs_sg.id}"]
  user_data            = "${data.template_file.user_data.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_ec2_instance.name}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "60"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data/user-data.sh")}"

  vars {
    cluster_name = "${aws_ecs_cluster.vault.name}"
  }
}

# Create a new load balancer
resource "aws_elb" "vault_elb_ecs" {
  name     = "${local.prefix}-vault-elb"
  subnets  = ["${var.private_subnets}"]
  internal = true

  listener {
    instance_port     = "6443"
    instance_protocol = "TCP"
    lb_port           = "443"
    lb_protocol       = "TCP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 3

    // As we are using an elb, we must specify parameters that keep it in there even if it is not initialized, sealed or not the leader.
    target   = "HTTPS:6443/v1/sys/health?standbyok=true&sealedcode=200&uninitcode=200"
    interval = 55
  }

  listener {
    instance_port     = "8001"
    instance_protocol = "HTTP"
    lb_port           = "80"
    lb_protocol       = "HTTP"
  }

  # health_check {
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 3
  #   timeout             = 3


  #   // As we are using an elb, we must specify parameters that keep it in there even if it is not initialized, sealed or not the leader.
  #   target   = "HTTP:8001/healthz"
  #   interval = 10
  # }

  tags {
    Name = "${local.prefix}-vault-elb"
  }
  security_groups = ["${aws_security_group.vault_elb_ecs_sg.id}"]
}

resource "aws_security_group" "vault_elb_ecs_sg" {
  name        = "${local.prefix}-vault-ecs-elb-sg"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC and from the transit VPC"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["${compact(list(var.vpc_subnet, var.transit_vpc_subnet_cidr))}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${local.prefix}-vault-ecs-elb-sg"
    Created-by  = "terraform"
    Environment = "${var.environment}"
    project     = "${var.project_name}"
  }
}

// autoscaling group
resource "aws_autoscaling_group" "vault_asg_ecs" {
  name                 = "${local.prefix}-vault-asg-ecs"
  launch_configuration = "${aws_launch_configuration.vault_ecs.name}"
  vpc_zone_identifier  = ["${var.private_subnets}"]
  load_balancers       = ["${aws_elb.vault_elb_ecs.name}"]

  min_size         = 3
  max_size         = 3
  desired_capacity = 3

  tag {
    key                 = "Name"
    value               = "${local.prefix}-vault-asg-ecs"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "project"
    value               = "${var.project_name}"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "vault_asg_ecs_sg" {
  name        = "${local.prefix}-vault-asg-ecs-sg"
  description = "Container Instance Allowed Ports"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 1
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_subnet}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${local.prefix}-vault-asg-ecs-sg"
    Created-by  = "terraform"
    Environment = "${var.environment}"
    project     = "${var.project_name}"
  }
}

resource "aws_route53_record" "vault" {
  zone_id = "${var.route53_zoneid}"
  name    = "${local.prefix}-vault"
  type    = "CNAME"
  ttl     = "30"
  records = ["${aws_elb.vault_elb_ecs.dns_name}"]
}
