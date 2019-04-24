# Vault module
This module runs vault in amazon ECS.
- https://www.vaultproject.io/

## Dependencies
- `vault` needs KMS encrypted TLS assets that will be passed to the vault container using "base64 encoded KMS cypherblob environment variables". You can blame ECS' lack of features for this step.
- `vaultguad` needs:
  - a KMS key to encrypt/decrypt sensitive data
  - an S3 bucket to store data

### encrypt TLS assets
- the TLS assets for vault have to first be generated locally and then KMS encrypted and set as variables for terraform
- install `cfssl` on your workstation/laptop
  - https://github.com/cloudflare/cfssl
- `cd tls/`
- generate new TLS assets

```
./gen-tls-assets.sh .
```
- encrypt the newly generated TLS assets
- `cd scripts/`

```
./encrypt.sh -k arn:aws:kms:eu-west-1:460402331925:key/4c4899af-2a3b-4ca2-a82d-78863371bb07
```
- the TLS files given as terraform formatted variables output from this command, should be added to the `test/vault/variables.tf` file for circleci. For your own dev-ing add these encrypted variables to a `encrypted.tfvars` file to override the circleci defaults.

NOTE: Docs Created with terraform-docs project


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| additional_ecs_instance_role_policy | a json policy document for the ecs instance role policy | `false` | no |
| additional_ecs_service_role_policy | a json policy document for the ecs service role policy | `false` | no |
| aws_asg_image_id | ecs optimised ec2 ami | `ami-ff15039b` | no |
| bucket_purpose | s3 bucket to be used to hold the state for vaultguard | `` | no |
| dynamodb_read_capacity | read capacity for dynamodb table | `5` | no |
| dynamodb_write_capacity | write capacity for dynamodb table | `5` | no |
| ec2_key_pair | Keypair for the created instances | - | yes |
| ecs_instance_type | The type of the aws ec2 instance that ecs runs on | `t2.micro` | no |
| ecs_vault_cpu | Share of the instance's CPU (out of 1024 * vCPUs ) for the vault container | - | yes |
| ecs_vault_mem | Amount of memory (in MB) for the vault container | - | yes |
| ecs_vaultguard_cpu | Share of the instance's CPU (out of 1024) for the vault container | `256` | no |
| ecs_vaultguard_mem | Amount of memory (in MB) for the vault container | `256` | no |
| enable_vaultguard | Enable the vault manager | `false` | no |
| environment | The environment the cluster is running in | - | yes |
| kms_key_arn | arn of the KMS key used for encryption | - | yes |
| namespace | a string to be used as the prefix for various AWS resources | `` | no |
| namespace_dynamodb_table | a string to be used as the prefix for the vault dynamodb table | `false` | no |
| namespace_log_group | a string to be used as the prefix for various AWS resources | `false` | no |
| private_subnets | Internal subnets the ecs cluster should be in | - | yes |
| project_name | The name of the project | - | yes |
| region | The region the AWS resources will run in | - | yes |
| route53_zoneid | The route53 zone id to create the vault record in | - | yes |
| transit_vpc_subnet_cidr | CIDR of the transit vpc to allow traffic to the vault elb. This CIDR must be different than the one in the private_subnet | `` | no |
| vault_encrypted_keys | KMS encrypted TLS assets used by vault. | - | yes |
| vaultguard_managed_vault_cluster | the target vault cluster that vaultguard will manage | `` | no |
| vaultguard_version | Vaultguard manager version | `` | no |
| vpc_id | The id of the VPC the cluster should be in | - | yes |
| vpc_subnet | Subnet range to firewall off the ecs cluster into | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| vault_tls_endpoint |  |

