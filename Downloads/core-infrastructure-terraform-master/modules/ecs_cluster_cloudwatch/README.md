
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_asg_name | alb asg name | string | - | yes |
| environment |  | string | - | yes |
| min_evaluation_period |  | string | `2` | no |
| min_period_secs | Min interval period | string | `60` | no |
| min_service_threshold | describe your variable | string | `1` | no |
| project_name | name of the project | string | - | yes |
| sns_major_topic_arn | sns topic to send major cloudwatch events to | string | - | yes |
| sns_minor_topic_arn | sns topic to send minor cloudwatch events to | string | - | yes |
