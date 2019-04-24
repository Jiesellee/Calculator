resource "aws_cloudwatch_log_group" "vault" {
  name              = "${var.project_name}/${var.environment}/${local.prefix}-vault"
  retention_in_days = 7

  tags {
    Name        = "${var.project_name}/${var.environment}/${local.prefix}-vault"
    Created-by  = "terraform"
    Environment = "${var.environment}"
    project     = "${var.project_name}"
    application = "vault"
  }
}

resource "aws_cloudwatch_log_group" "vaultguard" {
  name              = "${var.project_name}/${var.environment}/${local.prefix}-vaultguard"
  retention_in_days = 7

  tags {
    Name        = "${var.project_name}/${var.environment}/${local.prefix}-vaultguard"
    Created-by  = "terraform"
    Environment = "${var.environment}"
    project     = "${var.project_name}"
    application = "vaultguard"
  }

  count = "${var.enable_vaultguard ? 1 : 0}"
}

// vault ECS service definition and templates
resource "aws_ecs_service" "vault" {
  name                               = "vault"
  cluster                            = "${aws_ecs_cluster.vault.id}"
  task_definition                    = "${aws_ecs_task_definition.vault.arn}"
  desired_count                      = 3
  iam_role                           = "${aws_iam_role.ecs_scheduler.arn}"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0

  load_balancer {
    elb_name       = "${aws_elb.vault_elb_ecs.name}"
    container_name = "vault"
    container_port = 6443
  }
}

// vault task definition and templates
data "template_file" "vault_config" {
  template = "${file("${path.module}/task-definitions/vault-config.hcl.tpl")}"

  vars {
    region         = "${var.region}"
    project_name   = "${var.project_name}"
    environment    = "${var.environment}"
    elb_dns        = "https://${aws_route53_record.vault.fqdn}"
    dynamodb_table = "${local.prefix_dynamodb_table_vault}"
  }
}

data "template_file" "ecs_task_definition_vault" {
  template = "${file("${path.module}/task-definitions/vault-task.json.tpl")}"

  vars {
    ecs_vault_cpu        = "${var.ecs_vault_cpu}"
    ecs_vault_mem        = "${var.ecs_vault_mem}"
    project_name         = "${var.project_name}"
    environment          = "${var.environment}"
    region               = "${var.region}"
    vault_config_content = "${base64encode(data.template_file.vault_config.rendered)}"
    vault_pem            = "${var.vault_encrypted_keys["vault_pem"]}"
    vault_key_pem        = "${var.vault_encrypted_keys["vault_key_pem"]}"
    awslogs_group_path   = "${local.prefix_log_group_vault}"
  }
}

resource "aws_ecs_task_definition" "vault" {
  family                = "vault"
  container_definitions = "${data.template_file.ecs_task_definition_vault.rendered}"
  task_role_arn         = "${aws_iam_role.ecs_service.arn}"
}

// vaultguard ECS service definition and templates
resource "aws_ecs_service" "vaultguard" {
  name                               = "vaultguard"
  cluster                            = "${aws_ecs_cluster.vault.id}"
  task_definition                    = "${aws_ecs_task_definition.vaultguard.arn}"
  desired_count                      = 1
  iam_role                           = "${aws_iam_role.ecs_scheduler.arn}"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 0

  load_balancer {
    elb_name       = "${aws_elb.vault_elb_ecs.name}"
    container_name = "vaultguard"
    container_port = 8001
  }

  count = "${var.enable_vaultguard ? 1 : 0}"
}

// vaultguard task definition and templates
data "template_file" "vaultguard_config" {
  template = "${file("${path.module}/task-definitions/vaultguard-config.json.tpl")}"

  vars {
    region                           = "${var.region}"
    project_name                     = "${var.project_name}"
    environment                      = "${var.environment}"
    kms_key_arn                      = "${var.kms_key_arn}"
    vaultguard_state_s3_bucket       = "${module.vaultguard_bucket.bucket_name}"
    vaultguard_managed_vault_cluster = "${var.vaultguard_managed_vault_cluster}"
  }

  count = "${var.enable_vaultguard ? 1 : 0}"
}

data "template_file" "ecs_task_definition_vaultguard" {
  template = "${file("${path.module}/task-definitions/vaultguard-task.json.tpl")}"

  vars {
    ecs_vaultguard_cpu        = "${var.ecs_vaultguard_cpu}"
    ecs_vaultguard_mem        = "${var.ecs_vaultguard_mem}"
    project_name              = "${var.project_name}"
    environment               = "${var.environment}"
    region                    = "${var.region}"
    vaultguard_config_content = "${base64encode(data.template_file.vaultguard_config.rendered)}"
    vaultguard_version        = "${var.vaultguard_version}"
    awslogs_group_path        = "${local.prefix_log_group_vaultguard}"
  }

  count = "${var.enable_vaultguard ? 1 : 0}"
}

resource "aws_ecs_task_definition" "vaultguard" {
  family                = "vaultguard"
  container_definitions = "${data.template_file.ecs_task_definition_vaultguard.rendered}"
  task_role_arn         = "${aws_iam_role.ecs_service_vaultguard.arn}"

  count = "${var.enable_vaultguard ? 1 : 0}"
}
