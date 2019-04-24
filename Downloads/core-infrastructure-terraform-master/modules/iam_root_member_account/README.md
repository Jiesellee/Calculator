# IAM Root Member Account Module

This module creates appropriate groups for users and gives them access to the correct roles in organisation member accounts

## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| aws_account_ids | AWS account IDs that users should be allowed access to | - | yes |
| administrator_group_membership | list of users member of the administrator group | - | yes |
| developer_group_membership | list of users member of the developer group | - | yes |
| project_name | name of the project | - | yes |

