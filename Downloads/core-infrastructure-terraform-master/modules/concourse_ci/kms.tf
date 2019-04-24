// this is optional to allow local testing. 
data "aws_kms_secret" "postgres" {
  secret {
    name    = "postgres_password"
    payload = "${var.config_postgres_encrypted_password}"
  }
}

// this is optional to allow local testing. 
data "aws_kms_secret" "config_basic_auth" {
  secret {
    name    = "password"
    payload = "${var.config_basic_auth_encrypted_password}"
  }
}

data "aws_kms_secret" "config_github_auth" {
  secret {
    name    = "client_secret"
    payload = "${var.config_github_auth_client_secret}"
  }
}
