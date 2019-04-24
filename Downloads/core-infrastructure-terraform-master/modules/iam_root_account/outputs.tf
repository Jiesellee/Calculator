// use this whilst depends_on module is broken
// https://github.com/hashicorp/terraform/issues/10462
output "iam_user_usernames" {
  value = ["${aws_iam_user.users.*.name}"]
}

output "aws_iam_users_encrypted_passwords" {
  description = "A map of users and their temporary passwords encrypted with their pgp key"
  value       = "${zipmap(var.users, aws_iam_user_login_profile.users.*.encrypted_password)}"
}
