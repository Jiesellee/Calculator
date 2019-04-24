
## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| environment | the logical environment where this code will run in | - | yes |
| project_name | the project/product name | - | yes |
| sched_rot_interval | Time length in seconds for the amount of time a scheduled rotation for an on-call team should last | - | yes |
| sched_rot_start | The date and time when the rotation starts | - | yes |
| service_lookup | Project/product service lookup map used for outputs. | - | yes |
| services | Project/product services map[string]string. The format for the comma separated map values is **service_name, auto_resolve_timeout,acknowledgment_timeout,escalation_policy** | - | yes |
| team_doh_list | During office hours team that will be created in pagerduty for this product/project. | - | yes |
| team_ooh_list | Outside office hours team that will be created in pagerduty for this product/project. | - | yes |
| users_doh_ids | List of user ids to be added to the during office hours schedule | - | yes |
| users_ooh_ids | List of user ids to be added to the outside office hours schedule | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloudwatch_integration_keys |  |
| svc_id |  |
| svc_status |  |

