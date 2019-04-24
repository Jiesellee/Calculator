// Autoscaling group launch config
resource "aws_launch_configuration" "ecs" {
  image_id        = "${var.ecs_image_id}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.ec2_key_pair}"
  security_groups = ["${aws_security_group.ecs.id}"]

  // A little hacky, but this is ok for now.s
  user_data            = "${data.template_cloudinit_config.config.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"

  // Use a decent sized block device as docker containers can grow if not cleaned up.
  root_block_device {
    volume_type = "gp2"
    volume_size = "60"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  # Setup hello world script to be called by the cloud-config
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.init_script.rendered}"
  }

  // if provided render additional cloud config
  part {
    filename     = "additional.cfg"
    content_type = "text/cloud-config"
    content      = "${var.additional_cloud_config}"
    merge_type   = "list(append)+dict(recurse_array)+str()"
  }
}

data "template_file" "init_script" {
  template = "${file("${path.module}/user_data/init.tpl")}"

  vars {
    ecs_cluster_name = "${aws_ecs_cluster.default.name}"
    log_group_name   = "${var.environment}/ecs"
  }
}

// Create a autoscaling group
resource "aws_autoscaling_group" "ecs" {
  name                 = "${var.project_name}-${var.environment}-ecs-${var.instance_id}"
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  vpc_zone_identifier  = ["${var.private_subnets}"]
  enabled_metrics      = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances"]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-ecs-${var.instance_id}"
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

  min_size         = 1
  max_size         = 2
  desired_capacity = 2
}

resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-${var.environment}-ecs-${var.instance_id}"
  description = "Container Instance Allowed Ports"
  vpc_id      = "${var.vpc_id}"

  // we are using the ephemeral port range for containers
  ingress {
    from_port = 32768
    to_port   = 65535
    protocol  = "tcp"

    security_groups = ["${compact(list(aws_security_group.alb.id, var.additional_asg_ingress_security_group))}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.default.cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.project_name}-${var.environment}-ecs"
    created-by  = "terraform"
    environment = "${var.environment}"
    project     = "${var.project_name}"
  }
}

data "aws_vpc" "default" {
  id = "${var.vpc_id}"
}
