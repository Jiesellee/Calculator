//support multiple compute environments later
resource "aws_batch_compute_environment" "batch_compute_environment" {
  compute_environment_name = "${var.batch_compute_environment_name}"

  compute_resources {
    instance_role = "${var.ecs_instance_profile}"
    ec2_key_pair  = "${var.ec2_key_pair}"

    instance_type = [
      "${var.instance_type}",
    ]

    max_vcpus = "${var.max_cpus}"
    min_vcpus = "${var.min_cpus}"

    security_group_ids = ["${var.security_groups}"]

    subnets = ["${var.private_subnets}"]

    type = "EC2"
  }

  service_role = "${aws_iam_role.batch_service_role.arn}"
  type         = "MANAGED"

  depends_on = [
    "aws_iam_role_policy_attachment.batch_service_role",
  ]
}

resource "aws_batch_job_definition" "job_definition" {
  name  = "${var.batch_job_definition_name}"
  type  = "container"
  count = "${var.number_of_batch_job_definitions}"

  container_properties = "${lookup(var.batch_job_definitions, count.index)}"
}

resource "aws_batch_job_queue" "job_queue" {
  name     = "${var.batch_job_queue_name}"
  state    = "ENABLED"
  priority = "${var.job_priority}"

  compute_environments = [
    "${aws_batch_compute_environment.batch_compute_environment.arn}",
  ]
}
