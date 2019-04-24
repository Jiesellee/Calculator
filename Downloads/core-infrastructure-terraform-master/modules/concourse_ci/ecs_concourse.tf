resource "aws_ecs_cluster" "concourse" {
  name = "${var.project_name}-${var.environment}-ecs"
}

resource "aws_ecs_service" "concourse_web" {
  name                               = "concourse-web"
  cluster                            = "${aws_ecs_cluster.concourse.id}"
  task_definition                    = "${aws_ecs_task_definition.concourse_web.arn}"
  desired_count                      = "${var.concourse_atc_service_count}"
  iam_role                           = "${aws_iam_role.ecs_scheduler.arn}"
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  load_balancer {
    elb_name       = "${aws_elb.asg_elb.name}"
    container_name = "concourse-web"
    container_port = 8080
  }
}

data "template_file" "ecs_task_definition_concourse_web" {
  template = "${file("${path.module}/task-definitions/concourse-web.json.tpl")}"

  vars {
    // this isnt that nice as now its going into the task definition. This is slightly better than plain text, but ultimately this should be decoded on startup.
    postgres_password         = "${data.aws_kms_secret.postgres.postgres_password}"
    postgress_address         = "${aws_db_instance.postgres_concourse.address}"
    basic_auth_password       = "${data.aws_kms_secret.config_basic_auth.password}"
    github_auth_client_id     = "${var.config_github_auth_client_id}"
    github_auth_client_secret = "${data.aws_kms_secret.config_github_auth.client_secret}"
    github_auth_team          = "${var.config_github_auth_team}"
    external_url              = "${var.config_external_url}"
    ecs_web_cpu               = "${var.ecs_web_cpu}"
    ecs_web_memory            = "${var.ecs_web_memory}"

    // encrypted keys
    authorized_worker_keys = "${var.encrypted_keys["authorized_worker_keys"]}"
    session_signing_key    = "${var.encrypted_keys["session_signing_key"]}"
    tsa_host_key           = "${var.encrypted_keys["tsa_host_key"]}"

    additional_env_vars = "${var.web_additional_env_vars == "" ? jsonencode(map("name", "NULL", "value", "NULL")) : var.web_additional_env_vars}"

    concourse_version      = "${var.concourse_version}"
    concourse_init_version = "${var.concourse_init_version}"

    aws_log_group = "concourse-${var.project_name}-${var.environment}"
  }
}

resource "aws_ecs_task_definition" "concourse_web" {
  family                = "concourse-web"
  container_definitions = "${data.template_file.ecs_task_definition_concourse_web.rendered}"
  task_role_arn         = "${aws_iam_role.ecs_service.arn}"

  // these need to be manually put on the box right now
  volume {
    name      = "concourse-keys"
    host_path = "/opt/concourse/keys/web"
  }
}

// concourse worker ecs service
resource "aws_ecs_service" "concourse_worker" {
  name                               = "concourse-worker"
  cluster                            = "${aws_ecs_cluster.concourse.id}"
  task_definition                    = "${aws_ecs_task_definition.concourse_worker.arn}"
  desired_count                      = "${var.number_of_workers}"
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}

data "template_file" "ecs_task_definition_concourse_worker" {
  template = "${file("${path.module}/task-definitions/concourse-worker.json.tpl")}"

  vars {
    concourse_tsa_host = "${aws_elb.asg_elb.dns_name}"

    worker_key             = "${var.encrypted_keys["worker_key"]}"
    tsa_host_key_pub       = "${var.encrypted_keys["tsa_host_key_pub"]}"
    ecs_worker_cpu         = "${var.ecs_worker_cpu}"
    ecs_worker_memory      = "${var.ecs_worker_memory}"
    concourse_version      = "${var.concourse_version}"
    concourse_init_version = "${var.concourse_init_version}"
    aws_log_group          = "concourse-${var.project_name}-${var.environment}"
  }
}

resource "aws_ecs_task_definition" "concourse_worker" {
  family                = "concourse-worker"
  container_definitions = "${data.template_file.ecs_task_definition_concourse_worker.rendered}"
  task_role_arn         = "${aws_iam_role.ecs_service.arn}"

  volume {
    name      = "concourse-keys"
    host_path = "/opt/concourse/keys/worker"
  }

  volume {
    name      = "concourse-home"
    host_path = "/opt/concourse/worker-state"
  }

  volume {
    name      = "docker-dir"
    host_path = "/var/lib/docker"
  }
}
