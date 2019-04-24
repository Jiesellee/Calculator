
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_alb_arn_suffix | alb arn suffix | string | - | yes |
| cluster_name | name of the ECS cluster | string | - | yes |
| ecs_service_alb_target_group_arn_suffix | ecs service alb target group arn suffix | string | - | yes |
| environment |  | string | - | yes |
| log_group_name | log group name where filter is applied | string | - | yes |
| min_evaluation_period |  | string | `2` | no |
| min_period_secs | Min interval period | string | `60` | no |
| min_service_tasks | The minimum number of ecs tasks deployed for this service | string | `2` | no |
| min_service_threshold | describe your variable | string | `1` | no |
| project_name | name of the project | string | - | yes |
| service_name | name of the ECS service | string | - | yes |
| sns_major_topic_arn | sns topic to send major cloudwatch events to | string | - | yes |
| sns_minor_topic_arn | sns topic to send minor cloudwatch events to | string | - | yes |
| pattern_error | pattern string for service log error | string | { ($.level = \"error\" ) } | no |
| pattern_fatal | pattern string for service log fatal | string | { ($.level = \"fatal\" ) } | no |
| pattern_panic | pattern string for service log panic | string | { ($.level = \"panic\" ) } | no |
| enable_log_filtering | enables the log filtering and alarming | string | true | no |
| enable_elb_400_alarms | Enables alarming on returned 400 from the elb | string | true | no |