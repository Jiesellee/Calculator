# pagerduty module
This module allows a project to manage their pagerduty resources: teams,users,services,escalation policies ...

**Glossary**:
- `ooh`: outside office hours
- `doh`: during office hours

---
This module creates:
- 2 pagerduty teams: **outside office hours** and **during office hours** teams
- users that are assigned to one of the 2 teams
- 2 pagerduty schedules: an **outside office hours** and an **during office hours** schedule
- 2 escalation policies: an **outside office hours** and an **during office hours** escalation policies for the 2 teams defined above
- as many services as the team wants to define
- as many cloudwatch service integrations as the team wants to define

---


Pagerduty documentation
- https://support.pagerduty.com/docs/adding-removing-users

# teams and users
**Users and teams can only be instantiated once per project !**

**Don't attempt to create these 2 resources per environment!** This will make your CI runs fails, because pagerduty's API doesn't accept these 2 resources to be duplicated.

# all other pagerduty resources
All other pagerduty resources are safe to be instantiated more than >1 per environment.

# example
See the pagerduty Concourse CI testing module for examples of variable values.
[https://github.com/River-Island/core-infrastructure-terraform/tree/master/modules/test/pagerduty](https://github.com/River-Island/core-infrastructure-terraform/tree/master/modules/test/pagerduty)

# cloudwatch webhook URL
- at this time the pagerduty-provider `v0.1.2` doesn't output the webhook URLs for the cloudwatch integrations.
- you'll have to login to the pagerduty web UI and retrieve these webkhook URLs

# local testing and the pagerduty credentials
- to be able to develop locally against the test account you'll need a password store so that you're not hardcoding credentials in terraform variables
- the password store that I've successfully trialed and used, that has similar functionality and workflow with `aws-vault`,  is `pass` - https://www.passwordstore.org/
- add the pagerduty test account credentials for your pagerduty admin user to the passwordstore
```
pass add -m riverisland/pagerduty_tf_token_ci_test
```
- in the command line window where you'll invoke terraform , export the terraform provider variable
```
export TF_VAR_pagerduty_tf_token_ci_test=$(pass show riverisland/pagerduty-tf_token_ci_test | sed '2,$d')
```
- run terraform: plan / apply / ...

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| environment | the logical environment where this code will run in | string | - | yes |
| project_name | the project/product name | string | - | yes |
| sched_rot_interval | Time length in seconds for the amount of time a scheduled rotation for an on-call team should last | string | - | yes |
| sched_rot_start | The date and time when the rotation starts | string | - | yes |
| service_lookup | Project/product service lookup map used for outputs. | map | - | yes |
| services | Project/product services map[string]string. The format for the comma separated map values is **service_name, auto_resolve_timeout,acknowledgment_timeout,escalation_policy** | map | - | yes |
| team_doh_list | During office hours team that will be created in pagerduty for this product/project. | list | - | yes |
| team_ooh_list | Outside office hours team that will be created in pagerduty for this product/project. | list | - | yes |
| users_ids | List of user ids to be added to the outside office hours schedule | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| cloudwatch_integration_keys |  |
| svc_id |  |
| svc_status |  |
