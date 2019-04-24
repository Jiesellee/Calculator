// concourse_ci.tf
output "jump_box_fqdn" {
  value = "${aws_route53_record.jump_box.fqdn}"
}

output "aws_kms_key_concourse_ci" {
  value = "${aws_kms_key.concourse_ci.arn}"
}

output "route_53_zone_name_servers" {
  value = "${aws_route53_zone.management.name_servers}"
}
