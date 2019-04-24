# ses_2_s3 module

This module creates an email address that stores emails in an s3 bucket.
This is useful to validate ssl certificates with.

### How To

- Include the module in your account
- Run apply through CI and go monitor the domain to make sure its valdidated.
- send a test email to the ```mailbox_address``` output of the module and make sure you can see it in the s3 bucket it creates.
- Send a validation email from aws cert manager open it and click the link
- Success!
- remove the module to delete the resources as you no longer need it!

### Example

This can be seen [here](../../ses_2_s3) in the test module

## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| environment | name of the environment | - | yes |
| project_name | name of the project | - | yes |
| resource_tags | add aditional resource tags here such as cost center or anything to add to all taggable resources | `<map>` | no |
| domain | describe your variable | `"false"` | no |
| route53_zone_id | zone id to create the verification record in | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| mailbox_address | the address that you can send emails to |

