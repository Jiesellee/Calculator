# Concource CI Module

This module runs concourse CI in amazon ECS.

## Dependencies

When concourse runs, it needs KMS encrypted rsa keys in the environment variables. To do this you need to do a few manual steps after you initially create the cluster, then re apply the changes.

NOTE: You need to beable to use the encrypt action to the KMS key thats been created.

If you run the encrypt.sh script it should create you some keys and passwords, encrypt them and spit out some terraform friendly variables.

e.g:
```
./encrypt.sh -k arn:aws:kms:eu-west-1:460402331925:key/39f44603-2f59-4353-95b8-5539c1ec4d6e -s <your github oauth secret token!>
```

Get the output of that command and declare them in a map variable in a seperate file like ```encrypted_keys.tf``` then use that variable when you declare the module.

NOTE: Docs Created with terraform-docs project


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| additional_ecs_instance_role_policy | a json policy document for the ecs instance role policy | `false` | no |
| additional_ecs_service_role_policy | a json policy document for the ecs service role policy | `false` | no |
| aws_asg_image_id | ecs optimised ec2 ami | `ami-a7f2acc1` | no |
| concourse_atc_service_count | the desired number of concourse ATC service instances | `1` | no |
| concourse_ecs_desired_capacity | the desired capacity for the concourse autoscaling group that spawns ECS instances | `1` | no |
| concourse_ecs_max_size | the maximum size of the concourse autoscaling group that spawns ECS instances | `1` | no |
| concourse_ecs_min_size | the minimum size of the concourse autoscaling group that spawns ECS instances | `1` | no |
| concourse_init_version | concourse init container version | `0.0.3` | no |
| concourse_version | concourse ci docker image version fetched from dockerhub | `2.7.7` | no |
| config_basic_auth_encrypted_password | optinal kms encrypted blob | - | yes |
| config_external_url | url you will call in your browser to access concourse | - | yes |
| config_github_auth_client_id | Configure concourse to use github auth against an orgs team | - | yes |
| config_github_auth_client_secret | Configure concourse to use github auth against an orgs team | - | yes |
| config_github_auth_team |  | `River-Island/microservices` | no |
| config_postgres_encrypted_password | optional kms encrypted blob | - | yes |
| ec2_key_pair | Keypair for the created instances | - | yes |
| ecs_instance_type | The type of the aws ec2 instance that ecs runs on | `i3.xlarge` | no |
| ecs_web_cpu | Share of the instance's CPU (out of 1024) for the concourse web container | `256` | no |
| ecs_web_memory | Amount of memory (in MB) for the concourse web container | `512` | no |
| ecs_worker_cpu | Share of the instance's CPU (out of 1024) for the concourse worker container | `1024` | no |
| ecs_worker_memory | Amount of memory (in MB) for the concourse worker container | `4096` | no |
| encrypted_keys | KMS encrypted keys used for concourse to communicatie | - | yes |
| environment | The environment the cluster is running in | - | yes |
| kms_key_arn | arn of the KMS key used to encrypt the below keys | - | yes |
| postgres_multi_az | make postgres multi az | `true` | no |
| postgres_skip_final_snapshot | skip creating final rds snapshot | `false` | no |
| private_subnets | Internal subnets the ecs cluster should be in | - | yes |
| project_domain | The domain used for the service | - | yes |
| project_name | The name of the project | - | yes |
| public_subnets | Public subnets the external oauth2 proxy loadbalancer should be in | - | yes |
| snapshot_identifier | identifier for the snapshot to create the DB from | `` | no |
| transit_vpc_subnet_cidr | cidr of the transit vpc to allow traffic to the concourse elb | `` | no |
| vpc_id | The id of the VPC the cluster should be in | - | yes |
| vpc_subnet | Subnet range to firewall off the ecs cluster into | - | yes |
| web_additional_env_vars | environment variable json statements for the web ecs task | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| elb_dns_name |  |




Module Usage:

```
module "concourseci" {
  # commented out for easy testing.
  # source = "../concourseci"
  # use a versioned source
  source = "git::ssh://git@github.com/river-island/core-terraform.git//modules/vpc_base?ref=feda685ac3251dada968c209fc2b9dc2c3de2420"

  project_name                 = "test"
  project_domain               = "io"
  environment                  = "test"
  postgres_password            = "testtest"
  vpc_id                       = "${module.base.vpc_vpc_id}"
  public_subnets               = "${module.base.vpc_public_subnets}"
  private_subnets              = "${module.base.vpc_private_subnets}"
  vpc_subnet                   = "${module.base.vpc_cidr}"
  ec2_key_pair                 = "${module.base.aws_key_pair_key_name}"
  concourse_external_url       = "localhost"
  postgres_multi_az            = "false"
  postgres_skip_final_snapshot = "true"

  encrypted_keys = "${var.encrypted_keys}"
}
```
