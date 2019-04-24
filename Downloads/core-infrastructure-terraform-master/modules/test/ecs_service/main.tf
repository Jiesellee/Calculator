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

variable "project_name" {
  type    = "string"
  default = "ecs-service"
}

module "ecs_cluster" {
  source          = "../../ecs_cluster"
  instance_id     = "2"
  instance_type   = "t2.large"
  ec2_key_pair    = "${module.base.aws_key_pair_key_name}"
  project_name    = "${var.project_name}"
  environment     = "test"
  vpc_id          = "${module.base.vpc_vpc_id}"
  public_subnets  = "${module.base.vpc_public_subnets}"
  private_subnets = "${module.base.vpc_private_subnets}"
}

module "ecs_service" {
  source       = "../../ecs_service"
  service_name = "${var.project_name}"

  ecs_task_definition = <<EOF
[
  {
    "name": "test",
    "image": "nginx:stable-alpine",
    "cpu": 1,
    "memory": 1,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080
      }
    ]
  }
]
EOF

  listener_arn        = "${module.ecs_cluster.aws_alb_listener_arn}"
  vpc_id              = "${module.base.vpc_vpc_id}"
  priority            = 1
  alb_routing_method  = "host-header"
  alb_routing_pattern = "test.com"
  aws_ecs_cluster_arn = "${module.ecs_cluster.aws_ecs_cluster_arn}"
  service_name        = "test"
  project_name        = "${var.project_name}"
  environment         = "test"
  zone_id             = "${module.base.zone_id}"
  alb_dns_name        = "${module.ecs_cluster.alb_dns_name}"

  task_policy       = "true"
  task_policy_arn   = "${aws_iam_policy.default.arn}"
  target_group_hack = "test-dev"
}
