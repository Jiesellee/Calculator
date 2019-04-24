# s3 state bucket

This is used to store state in S3.
An instance of this bucket should exist for each environment in a centralised management account.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket_purpose | purpose for the bucket | string | `tf-state` | no |
| delegated_access_account_ids | Account IDs allowed to read the remote state bucket | map | `<map>` | no |
| environment | the environment this bucket is used for | string | - | yes |
| force_destroy_s3_bucket | Flag that marks the bucket as destroy-able for terraform, even if the bucket is not empty. | string | `false` | no |
| namespace_prefix | a prefix for the namespace | string | `` | no |
| project_name | name of the project | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket_name |  |



## Example

```
module "s3_state_management" {
  source       = "../s3_state_bucket"
  environment  = "dev"
  project_name = "${var.project_name}"
  delegated_access_account_ids = {
    enactor-dev = "432524534"
    enactor-staging = "45345435"
  }
}
```
