storage "dynamodb" {
  ha_enabled    = "true"
  region        = "${region}"
  table         = "${dynamodb_table}"
}

listener "tcp" {
  address = "0.0.0.0:6443"
  tls_key_file = "/vault/tls/vault-key.pem"
  tls_cert_file = "/vault/tls/vault.pem"
}

disable_mlock = "true"
