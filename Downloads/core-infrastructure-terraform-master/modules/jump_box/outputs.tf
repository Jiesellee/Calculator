output "ip_address" {
  value = "${coalesce(aws_instance.jump_box.public_ip, aws_instance.jump_box.private_ip)}"
}

output "security_group_id" {
  value = "${aws_security_group.allow_ssh.id}"
}
