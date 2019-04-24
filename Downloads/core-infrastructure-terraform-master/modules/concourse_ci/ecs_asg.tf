data "aws_ami" "ecs_optimized" {
  most_recent = true

  filter {
    name = "name"

    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  //amazon owner id
  owners = ["amazon"]
}

// launch config
resource "aws_launch_configuration" "ecs" {
  image_id = "${data.aws_ami.ecs_optimized.id}"

  instance_type        = "${var.ecs_instance_type}"
  key_name             = "${var.ec2_key_pair}"
  security_groups      = ["${aws_security_group.ecs.id}"]
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
    cluster_name = "${aws_ecs_cluster.default.name}"
  }
}

// autoscaling group
resource "aws_autoscaling_group" "ecs" {
  name                 = "${var.project_name}-${var.environment}-ecs"
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  vpc_zone_identifier  = ["${var.private_subnets}"]
  load_balancers       = ["${aws_elb.asg_elb.name}"]

  min_size         = "${var.concourse_ecs_min_size}"
  max_size         = "${var.concourse_ecs_max_size}"
  desired_capacity = "${var.concourse_ecs_desired_capacity}"

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-ecs"
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

/* ecs service cluster */
resource "aws_ecs_cluster" "default" {
  name = "${var.project_name}-${var.environment}-ecs"
}

resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-${var.environment}-ecs"
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
    Name = "${var.project_name}-${var.environment}-ecs"
  }
}

# Create a new load balancer
resource "aws_elb" "asg_elb" {
  name     = "${var.project_name}-${var.environment}-ecs"
  subnets  = ["${var.private_subnets}"]
  internal = true

  listener {
    instance_port     = "8080"
    instance_protocol = "http"
    lb_port           = "80"
    lb_protocol       = "http"
  }

  listener {
    instance_port     = "2222"
    instance_protocol = "tcp"
    lb_port           = "2222"
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }

  tags {
    Name = "${var.project_name}-${var.environment}-ecs"
  }

  security_groups = ["${aws_security_group.asg_elb.id}"]
}

resource "aws_security_group" "asg_elb" {
  name        = "${var.project_name}-${var.environment}-elb-ecs"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.project_name}-${var.environment}-elb-ecs"
    Created-by  = "terraform"
    Environment = "${var.environment}"
    project     = "${var.project_name}"
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["${compact(list(var.vpc_subnet, var.transit_vpc_subnet_cidr))}"]
  }

  ingress {
    from_port = 2222
    to_port   = 2222
    protocol  = "tcp"

    cidr_blocks = ["${var.vpc_subnet}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
