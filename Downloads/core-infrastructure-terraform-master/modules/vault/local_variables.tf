locals {
  prefix = "${
    var.namespace == "" ?
    format("%s-%s", var.project_name, var.environment) :
    format("%s-%s-%s", var.project_name, var.environment, var.namespace)
  }"
}

# s3 bucket local var
locals {
  bucket_purpose_suffix = "${
    var.bucket_purpose == "" ?
    "tf-state" :
    format("%s-state", var.bucket_purpose)
  }"
}

# log_group
locals {
  prefix_log_group_vault = "${
    var.namespace_log_group ?
    format("%s/%s/%s-%s-%s-vault", var.project_name, var.environment, var.project_name, var.environment, var.namespace) :
    format("%s/%s/vault", var.project_name, var.environment)
  }"
}

locals {
  prefix_log_group_vaultguard = "${
    var.namespace_log_group ?
    format("%s/%s/%s-%s-%s-vaultguard", var.project_name, var.environment, var.project_name, var.environment, var.namespace) :
    format("%s/%s/vaultguard", var.project_name, var.environment)
  }"
}

# dynamodb table name
locals {
  prefix_dynamodb_table_vault = "${
    var.namespace_dynamodb_table ?
    format("%s-%s-%s-vault-table", var.project_name, var.environment, var.namespace) :
    format("%s-%s-vault-table", var.project_name, var.environment)
  }"
}
