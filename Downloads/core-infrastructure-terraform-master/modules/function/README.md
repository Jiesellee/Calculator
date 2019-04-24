
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| default_security_group_id | The id of the security groups to apply to the labda by default | string | - | yes |
| deployment_package_filename | A relative path to the zip file to deploy | string | - | yes |
| environment | The environment where this runs | string | - | yes |
| function_description | A lambda function within the order scope | string | - | yes |
| function_environment_variables | A map of environment variables to pass to the lambda function | map | - | yes |
| function_handler | The function handler | string | `index.handle` | no |
| function_name | The name of the function you are deploying | string | - | yes |
| function_runtime | The funciton runtime | string | `nodejs4.3` | no |
| lambda_memory | The default lambda memory limit | string | `1024` | no |
| lambda_role_policy | The policy of the role to be applied to the lambda function | string | - | yes |
| lambda_timeout | The default lambda execution timeout | string | `300` | no |
| monitoring_sns_arn | The arn of where to send the monitoring messages | string | - | yes |
| private_subnets | A list of the private subnets in which to deploy the lambda | list | - | yes |
| vpc_id | The id of the vpc the lambda will run in | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn |  |
| function_name |  |
| invoke_arn |  |

