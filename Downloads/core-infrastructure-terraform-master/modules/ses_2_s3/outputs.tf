output "mailbox_address" {
  value = "hostmaster@${var.domain != "false" ? var.domain: "${var.environment}.${var.project_name}.ri-tech.io" }"
}
