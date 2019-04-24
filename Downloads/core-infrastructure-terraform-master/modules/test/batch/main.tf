provider "aws" {
  # this is the test account id
  allowed_account_ids = ["460402331925"]
  region              = "eu-west-1"
}

// sets up a single az vpc and a keypair
module "base" {
  source = "../base"

  namespace   = "${var.project_name}"
  module_name = "${var.project_name}"
}

module "batch" {
  source = "../../batch"

  project_name                    = "${var.project_name}"
  environment                     = "test"
  private_subnets                 = "${module.base.vpc_private_subnets}"
  security_groups                 = ["${module.base.aws_security_group}"]
  instance_type                   = "optimal"
  min_cpus                        = "0"
  max_cpus                        = "8"
  job_priority                    = "1"
  batch_compute_environment_name  = "test_batch_compute_environment"
  batch_job_definition_name       = "test_batch_job_definition"
  batch_job_queue_name            = "test_batch_queue"
  number_of_batch_job_definitions = 1

  batch_job_definitions = {
    "0" = "${data.template_file.container_properties.rendered}"
  }

  ec2_key_pair         = "${module.base.aws_key_pair_key_name}"
  ecs_instance_profile = "${aws_iam_instance_profile.batch_compute_env_role.arn}"
}

data "template_file" "container_properties" {
  template = "${file("${path.module}/service.json")}"

  vars {
    image      = "460402331925.dkr.ecr.eu-west-1.amazonaws.com/pgw-poc/awsbatch"
    memory     = 1024
    vcpus      = 1
    jobRoleArn = "${aws_iam_role.batch_job_definition_role.arn}"
  }
}

resource "aws_iam_role" "batch_compute_env_role" {
  name = "batch_compute_env_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
	  "Action": "sts:AssumeRole",
	  "Effect": "Allow",
	  "Principal": {
	  "Service": "ec2.amazonaws.com"
	  }
    }
    ]
}
EOF
}

resource "aws_iam_role" "batch_job_definition_role" {
  name = "batch_job_definition_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
	  "Action": "sts:AssumeRole",
	  "Effect": "Allow",
	  "Principal": {
	  "Service": "ecs-tasks.amazonaws.com"
	  }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "batch_compute_env_ec2_instance_policy" {
  role       = "${aws_iam_role.batch_compute_env_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "batch_job_definition_ec2_instance_policy" {
  role       = "${aws_iam_role.batch_job_definition_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "batch_job_definition_ecs_task_execution_policy" {
  role       = "${aws_iam_role.batch_job_definition_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_instance_profile" "batch_compute_env_role" {
  name = "batch_compute_env_role"
  role = "${aws_iam_role.batch_compute_env_role.name}"
}

resource "aws_iam_instance_profile" "batch_job_definition_role" {
  name = "batch_job_definition_role"
  role = "${aws_iam_role.batch_job_definition_role.name}"
}
