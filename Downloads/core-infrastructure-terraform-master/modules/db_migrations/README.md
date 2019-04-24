# DB Migration module

This module create an ecs task that will enable you to run the db migrations on your ecs cluster against your db.

to use this module, do the following:
- include it in your services terraform module [like so]()
- add the appropriate outputs to 
  - your module [like so](https://github.com/River-Island/payment-processor/blob/master/terraform/modules/api/db_migrations.tf#L15)
  - your environments [like so](https://github.com/River-Island/payment-processor/blob/master/terraform/providers/aws/dev/main.tf#L49#L55)
- run the outputted script in your CI [like so](https://github.com/River-Island/payment-processor/blob/master/ci/payment-processor_pipeline.yml#L101)

### Caveats
This module contains a shell script that runs the task and polls for its exit status. This script is pretty horrible, and the idea that terraform spits it out is undesireable too.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| db_name | database name | string | - | yes |
| db_password | database password | string | - | yes |
| db_url | database url | string | - | yes |
| db_username | database username | string | - | yes |
| ecr_image | ecr registry address in the format of ${ACCOUNT_ID}.dkr.ecr.eu-west-1.amazonaws.com/${REPO_NAME} | string | - | yes |
| ecr_image_tag | version of the container | string | - | yes |
| override_flyway_command | override flyway_command | string | ` ` | no |
| service_name | the name of the service | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws_ecs_task_definition_name |  |

A shell script into the root terraform location called ```deploy_script.sh``` this is not ideal.
