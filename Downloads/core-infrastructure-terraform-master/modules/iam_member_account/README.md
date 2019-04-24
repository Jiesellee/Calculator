# IAM Member Account Module

This module creates the correct IAM roles and policies in organisation memeber accounts.

It creates the following:
- administrator role
- developer role
- read only access policy
- allow all access policy 


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_iam_root_account_id | account id of the root IAM account | string | `667800118351` | no |
| aws_management_account_id | This is the management account id where the continious delivery server sits | string | `002540887416` | no |
| aws_monitoring_account_id | account id allowed to assume the cloudwatch role and monitor it | string | `false` | no |
| aws_product_management_account_id | This is the management account id of the product/project where the continious delivery server sits | string | `` | no |
| developers_full_access | give the developers group full access to this account | string | `false` | no |
| operations_full_access | give the developers group full access to this account | string | `false` | no |
| override_administrator_policy | override the policy | string | `false` | no |
| override_administrator_policy_arn | name of the policy to override | string | `` | no |
| override_administrator_role_policy | override the policy | string | `false` | no |
| override_administrator_role_policy_arn | name of the policy to override | string | `` | no |
| override_developer_role_policy | override the policy | string | `false` | no |
| override_developer_role_policy_arn | name of the policy to override | string | `` | no |
| override_operations_role_policy | name of the policy to override | string | `false` | no |
| override_operations_role_policy_arn | name of the policy to override | string | `` | no |
| override_read_only_policy | override the policy | string | `false` | no |
| override_read_only_policy_arn | name of the policy to override | string | `` | no |
| test_environment | describe your variable | string | `false` | no |


## Outputs

| Name | Description |
|------|-------------|
| iam_switch_role_link |  |

