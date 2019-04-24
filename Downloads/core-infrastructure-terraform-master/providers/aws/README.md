# AWS Accounts

This folder holds high level terraform code to set up all AWS accounts.

The code in here should be concerned with the following
- Infrastructure related accounts
  - Transit VPCs
  - Management
  - Monitoring & logging
  - IAM Users
- Setting up all product accounts with the correct roles, policies, s3 buckets, cloudtrail setup etc

## Setting up a new AWS Account

Creating a new account is done in AWS organisations. Log into the root account through switching an IAM role, and create a new account in the GUI. Currently there is no support for aws organisations. Once this is done, add it to [this documentation](https://github.com/River-Island/architecture/blob/master/documentation/accounts.md)

Once youv'e done this, you need to set up the new accounts in this repo.

A good example of how to set up a new product account can be seen in the [Order development account](https://github.com/River-Island/core-infrastructure-terraform/blob/master/infra/providers/aws/order_dev/main.tf)

By using the modules in this repo, we can easily set up all the basic access we need to get started.
When you want to deploy product related infrastructure create a new github repo for your terraform code called
```${product_name}-terraform```

A good example of this can be seen in the [order project](https://github.com/River-Island/order-terraform) again.
