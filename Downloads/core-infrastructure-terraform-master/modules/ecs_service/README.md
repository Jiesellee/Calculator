# ECS Service module

This is used by the application terraform code to create and deploy a service and assign it to an ALB listener.

What this does:
  - Create ECS service
  - Assign an ALB to it
  - Accept basic options such as memory, cpu and image name + tag.
  - Output sufficient info for other modules

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb_dns_name | DNS for the alb | string | - | yes |
| alb_routing_method | Routing method; Must be path-pattern or host-header | string | `host-header` | no |
| alb_routing_pattern | Your path-pattern or host-header that you want to route on | string | - | yes |
| aws_ecs_cluster_arn | ID of the ECS cluster | string | - | yes |
| desired_task_count | The desired count of running tasks. This is useful for ensuring uptime. | string | `1` | no |
| ecs_service_deployment_maximum_percent | maximum percentage of containers to remain active during a deploy | string | `100` | no |
| ecs_service_deployment_minimum_healthy_percent | minimum percentage of containers to remain active during a deploy | string | `50` | no |
| ecs_service_desired_task_count | desired number of containers (tasks) that should be active | string | `2` | no |
| ecs_task_definition | rendered ecs task definition in json | string | - | yes |
| efs_host_path | folder where efs volume is going to be mounted | string | `/mnt/efs` | no |
| environment | environment name to tag resources with | string | - | yes |
| health_check_path |  | string | `/` | no |
| listener_arn | arn of the alb listener | string | `"` | if http is enabled |
| listener_ssl_arn | arn of the ssl alb listener | string | `"` | if https is enabled |
| priority | The priority of the rule | string | - | yes |
| project_name | project name to tag resources with | string | - | yes |
| service_name | Name of the ECS service | string | - | yes |
| service_port | Default container port the service listens on | string | `8080` | no |
| task_policy | enable attaching an additional policy to the ECS task definition | string | `false` | no |
| task_policy_arn | additional policy ARN to attach to the ECS task definition | string | `` | no |
| vpc_id | ID of the VPC this sits in | string | - | yes |
| zone_id | dns zone id for ecs cluster | string | - | yes |
| enable_http_listener | toggle for enabling http listener to the service from the load balancer | string | true | no |
| enable_https_listener | toggle for enabling https listener to the service from the load balancer | string | false | no |


## Outputs

| Name | Description |
|------|-------------|
| alb_target_group_arn |  |
| alb_target_group_arn_suffix |  |


## Example

`
module "alb_listener" {
  source = "../alb_listener"
  listener_arn = "${aws_alb_listener.external.arn}"
  vpc_id = "${module.vpc_base.vpc_id}"
  port = 8888
  service_name = "service_name"
  path = "/service_name/*"
  priority = 99
  alb_routing_pattern = "/service/*"
}
`
