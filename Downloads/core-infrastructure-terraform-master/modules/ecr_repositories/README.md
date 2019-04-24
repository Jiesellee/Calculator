# ECS Service module

This is used by the project terraform code to create ecr repositories.

What this does:
  - Create ECR repositories
  - Setup policy to allow project accounts (dev, staging, prod, etc) to access them
  - Accept repository names and allowed account ids
  - Output registry ids and repository urls 


## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| repository_names | list: names of the repositories to create | empty list | no |
| allowed_account_ids | list: ids of accounts allowed to read from those repositories | empty list | no |

## Outputs

| Name | Description |
|------|-------------|
| registry_ids | a list of registry ids in which the repositories are created in |
| repository_urls | a list of repository urls |

## Example

`
module "ecr_repositories" {
  source = "../ecr_repositories"
  repository_names = ["app1", "app2", "app3"]
  allowed_account_ids = [ "<dev-account-id>", "<staging-account-id>", "<prod-account-id>"]
}
`
