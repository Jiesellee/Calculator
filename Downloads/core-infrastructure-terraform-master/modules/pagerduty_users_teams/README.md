# pagerduty_users_teams
Look at the main pagerduty readme to find out more about the pagerduty terraform setup - [https://github.com/River-Island/core-infrastructure-terraform/blob/master/modules/pagerduty/README.md](https://github.com/River-Island/core-infrastructure-terraform/blob/master/modules/pagerduty/README.md)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| environment | the environment in which terraform is running e.g. ci | string | - | yes |
| project_name | name of project | string | - | yes |
| team_doh | During office hours team that will be created in pagerduty for this product/project. | string | - | yes |
| team_ooh | Outside office hours team that will be created in pagerduty for this product/project. | string | - | yes |
| user_emails | Map of user emails. **Each user is assigned an index to stop terraform from reordering resources. The order of the indexes must match the order of the user_names indexes** | map | - | yes |
| user_pg_roles | Map of pagerduty user roles. **Each user is assigned an index to stop terraform from reordering resources. The order of the indexes must match the order of the user_names indexes** | map | - | yes |
| users | Map of user names. **Can only be instantiated once per project, don't use per environment**.  Each user is assigned an index to ensure the same order is kept and terraform doesn't re-create users that it has already created. | map | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| team_doh_id_list |  |
| team_ooh_id_list |  |
| user_id_list |  |

