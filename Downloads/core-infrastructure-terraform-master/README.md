# Core Infrastructure
[Concourse CI Pipeline](http://management-concourse.prod.transit.ri-tech.io/teams/aws-operations/pipelines/core-infrastructure-terraform)

This repo aims to provide a few different things to facilitate project infrastructure development, and run core infrastructure components.

### Contents
  - Best practices
  - Core modules to be used as a basis for projects
  - Core infrastructure that all projects depend on
  - [Adding a new IAM user](https://github.com/River-Island/core-infrastructure-terraform/blob/master/providers/aws/iam/Readme.md)
  - [AWS Accounts](https://github.com/River-Island/core-infrastructure-terraform/blob/master/providers/aws/README.md)
  - [Testing Infrastructure](/modules/test/Readme.md)


### Guidance material

- Hashicorp's [best practices](https://github.com/hashicorp/best-practices/tree/master/terraform)

- Hashicorps reccommendation on how to manage [multiple environments ](https://atlas.hashicorp.com/help/intro/use-cases/multiple-environments)

- Organisation Module Hirarchy [here](https://github.com/hashicorp/terraform/issues/3838)

### Repo layout
- The modules folder contains modules that facilitate isolation and reuse.

- The modules test folder facilitates testing of modules in an isolated manner, and provides examples of how to use them.

- The providers folder contains environment/account specific terraform code that should only contain modules if used more than once.

### Core Infrastructure Components
  - [Route53 Zone ri-tech.io](modules/core/Readme.md)
  - [Terraform State Buckets](modules/s3_state_bucket/Readme.md)
  - [Transit Proxy Servers](modules/proxy_servers/Readme.md)
  - [Transit Account Setup](modules/transit/Readme.md)
  - [IAM Master Account Setup](modules/iam_master_account/Readme.md)
  - [Management Account Setup](modules/management_account/Readme.md)

### Repo Structure

```
  .
  ├── README.md
  ├── infra ---------- Holds real core infrastructure
  │   └── providers -- Holds providers like AWS, Github, Fastly etc
  │       └── aws ---- Holds indiviual AWS accounts (product environments/core components) for a provider.
  └── modules -------- Holds modules used in the core infra, but also modules to be reused or referenced to by projects if they so wish.
      └── test --------Holds test modules that test the module in isolation in a seperate account

  4 directories, 1 file
```
