# Jump Box module

Creates a simpe ssh jumpbox.

## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| project_name | name of the project | - | yes |
| environment | environment the jump box is in | - | yes |
| ssh_key_name | ssh keypair name for the jumpbox | - | yes |
| subnet | subnet to build the jumpbox in | - | yes |
| public | assign public ip to instance | `"false"` | no |
| jump_box_allowed_range_enable | punch a hole in the security group for a specific ip address cidr | `"false"` | no |
| jump_box_allowed_range | allowed cidr range to access the jumpbox | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| ip_address |  |

