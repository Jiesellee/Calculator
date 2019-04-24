// useful for humans to write secrets to the concourse path
path "auth/token/*" {
  capabilities = [
    "create",
    "update",
    "read",
    "list",
    "delete",
    "sudo"
  ]
}

path "sys" {
  capabilities = [
    "create",
    "update",
    "read",
    "list",
    "delete",
    "sudo"
  ]
}

path "concourse/*" {
  capabilities = [
    "create",
    "read",
    "update",
    "delete",
    "list"
  ]
}
