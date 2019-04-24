
## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| aws_ssh_key_file | describe your variable | `default` | no |
| bucket_purpose | suffix to be added to the name of the s3 bucket which holds the states for vaultguard | `vaultguard` | no |
| concourse_atc_service_count | the desired number of concourse ATC service instances | `2` | no |
| concourse_ci_encrypted_keys | concourse ci encrypted keys | `<map>` | no |
| concourse_ecs_desired_capacity | the desired capacity for the concourse autoscaling group that spawns ECS instances | `1` | no |
| concourse_ecs_max_size | the maximum size of the concourse autoscaling group that spawns ECS instances | `3` | no |
| concourse_ecs_min_size | the minimum size of the concourse autoscaling group that spawns ECS instances | `1` | no |
| dev_transit_vpc_account_id | the id of the account that the transit vpc sits in | `556748783639` | no |
| dev_transit_vpc_id | the id of the transit vpc that has the direct connect connection attached | `vpc-2ee35b4a` | no |
| dev_transit_vpc_peering | Peer to the transit vpc in another account | `false` | no |
| dev_transit_vpc_subnet_cidr | CIDR of vpc subnet to route to | `10.201.0.0/16` | no |
| dynamodb_read_capacity | arn of the KMS key used to encrypt the TLS assets | `10` | no |
| dynamodb_write_capacity | arn of the KMS key used to encrypt the TLS assets | `5` | no |
| ecr_repo_concourse_ci_allowed_aws_accounts_ro | read only access to concourse ci ecr repo | `<list>` | no |
| ecs_instance_type | The type of the aws ec2 instance that ecs runs on | `c4.large` | no |
| ecs_service_name_vault | ECS service name | `vault` | no |
| ecs_service_name_vaultguard | ECS service name | `vaultguard` | no |
| ecs_vault_cpu | Share of the instance's CPU (out of 1024) for the vault container | `1024` | no |
| ecs_vault_managed_vault_cpu | Share of the instance's CPU (out of 1024) for the vault container | `512` | no |
| ecs_vault_managed_vault_mem | Amount of memory (in MB) for the vault container | `2048` | no |
| ecs_vault_mem | Amount of memory (in MB) for the vault container | `2048` | no |
| ecs_vaultguard_cpu | Share of the instance's CPU (out of 1024) for the vault container | `512` | no |
| ecs_vaultguard_mem | Amount of memory (in MB) for the vault container | `256` | no |
| environment | environment | `prod` | no |
| module_instance_id | module id enabling multiple invocations of the module in the same account avoiding resource naming clashes | `0` | no |
| namespace | a string to be used as the prefix for various AWS resources | `b529870` | no |
| private_subnets | private subnet cidrs | `<list>` | no |
| prod_transit_vpc_account_id | the id of the account that the transit vpc sits in | `376076567968` | no |
| prod_transit_vpc_id | the id of the transit vpc that has the direct connect connection attached | `vpc-2efefe4a` | no |
| prod_transit_vpc_peering | Peer to the transit vpc in another account | `false` | no |
| prod_transit_vpc_subnet_cidr | CIDR of vpc subnet to route to | `10.202.0.0/22` | no |
| project_name | Name of the project | `management` | no |
| public_subnets | public subnet cidrs | `<list>` | no |
| region | The region the AWS resources will run in | `eu-west-1` | no |
| vault_encrypted_keys |  | `<map>` | no |
| vault_managed_uuid | a string to be used as the prefix for various AWS resources | `v2103` | no |
| vpc_cidr | vpc cidr | `10.202.100.0/22` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws_kms_key_concourse_ci |  |
| jump_box_fqdn | concourse_ci.tf |
| route_53_zone_name_servers |  |
| s3_shared_assets_bucket_name |  |

