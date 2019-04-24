output "elb_dns_name" {
  description = "the dns name of the elb created for concourse ci"
  value       = "${aws_elb.asg_elb.dns_name}"
}
