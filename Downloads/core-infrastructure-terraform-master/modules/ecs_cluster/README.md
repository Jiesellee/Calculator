# ecs_cluster terraform module

This creates:
  - An ECS cluster
  - Instances running the ECS agent in an autoscaling group
  - An application load balancer 

## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| instance_type | Tiny instances for docker containers | `"t2.medium"` | no |
| ec2_key_pair | ec2 keypair to use with the ECS instances | - | yes |
| instance_id | the unique instance id of the module | - | yes |
| project_name | name of the project | - | yes |
| environment | environment of the project | - | yes |
| vpc_id | VPC id | - | yes |
| private_subnets | private subnets for ECS cluster nodes | - | yes |
| public_subnets | public subnets for AWS ALB | - | yes |
| ecs_image_id | ecs optimised ec2 ami | `"ami-a7f2acc1"` | no |
| alb_allowed_cidr_blocks | list of allowed IPs on the ELB created | - | yes |
| additional_cloud_config | additional cloud config in cloud for the ec2 instances | `""` | no |
| additional_asg_ingress_security_group | add additional security groups to asg instances ingres | `""` | no |
| enable_elb_ssl | enables ssl lb listener on the cluster forwards to same http target group | false | no |
| ssl_policy | ssl policy for https lb listener | `"ELBSecurityPolicy-2016-08"` | no |
| ssl_certificate_arn | ssl certificate arn for https lb listener | `""` | no |


## Outputs

| Name | Description |
|------|-------------|
| alb_dns_name |  |
| alb_zone_id |  |
| aws_alb_target_group_arn |  |
| aws_ecs_cluster_arn |  |
| aws_alb_listener_arn |  |
| aws_alb_listener_ssl_arn | Access this ONLY IF enable_elb_ssl is set to true |
| aws_security_group_asg_id |  |
| alb_arn_suffix |  |
| aws_alb_target_group_arn_suffix |  |
| aws_asg_name |  |


## Example
`
module "ecs_service" {
  source = "../../../../core-infrastructure-terraform/modules/ecs_service"
  service_name = "webapp"
  project_name = "${var.project_name}"
  environment = "${var.environment}"
  path = "/*"
  priority = 99
  vpc_id = "${data.terraform_remote_state.environment.vpc_id}"
  listener_arn = "${data.terraform_remote_state.environment.aws_alb_listener_arn}"
  aws_ecs_cluster_arn = "${data.terraform_remote_state.environment.aws_ecs_cluster_arn}"
  ecs_task_definition = "${template_file.ecs_task_definition.rendered}"
}
`
