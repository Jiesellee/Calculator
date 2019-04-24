
## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| project_name | describe your variable | - | yes |
| team_doh | During office hours team that will be created in pagerduty for this product/project. | - | yes |
| team_ooh | Outside office hours team that will be created in pagerduty for this product/project. | - | yes |
| user_emails_doh | Map of user emails. **Each user is assigned an index to stop terraform from reordering resources. The order of the indexes must match the order of the user_names indexes** | - | yes |
| user_emails_ooh | Map of user emails. **Each user is assigned an index to stop terraform from reordering resources. The order of the indexes must match the order of the user_names indexes** | - | yes |
| user_pg_roles_doh | Map of pagerduty user roles. **Each user is assigned an index to stop terraform from reordering resources. The order of the indexes must match the order of the user_names indexes** | - | yes |
| user_pg_roles_ooh | Map of pagerduty user roles. **Each user is assigned an index to stop terraform from reordering resources. The order of the indexes must match the order of the user_names indexes** | - | yes |
| users_doh | Map of user names. **Can only be instantiated once per project, don't use per environment**. Each user is assigned an index to ensure the same order is kept and terraform doesn't re-create users that it has already created. | - | yes |
| users_ooh | Map of user names. **Can only be instantiated once per project, don't use per environment**.  Each user is assigned an index to ensure the same order is kept and terraform doesn't re-create users that it has already created. | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| team_doh_id_list |  |
| team_ooh_id_list |  |
| user_doh_id_list |  |
| user_ooh_id_list |  |

