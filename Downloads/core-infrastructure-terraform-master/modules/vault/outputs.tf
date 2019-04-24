output "vault_tls_endpoint" {
  value = "https://${aws_route53_record.vault.fqdn}"
}
