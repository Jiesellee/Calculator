/* module outputs */

output "alb_dns_name" {
  value = "${aws_alb.default.dns_name}"

  // outputs dont support descriptions yet!

  // description = "Output the dns name of the load balancer for DNS records"
}

output "alb_zone_id" {
  value = "${aws_alb.default.zone_id}"

  // outputs dont support descriptions yet!

  // description = "Output the dns zone of the load balancer for DNS alias record"
}

output "aws_alb_target_group_arn" {
  value = "${aws_alb_target_group.default.arn}"

  // description = "The arn of the default target group"
}

output "aws_ecs_cluster_arn" {
  value = "${aws_ecs_cluster.default.id}"
}

output "aws_ecs_cluster_name" {
  value = "${aws_ecs_cluster.default.name}"
}

output "aws_alb_listener_arn" {
  value = "${aws_alb_listener.default_http.arn}"
}

//Ugly but apparently 'accepted' as per https://www.terraform.io/upgrade-guides/0-11.html 
output "aws_alb_listener_ssl_arn" {
  value = "${element(concat(aws_alb_listener.default_https.*.arn, list("")), 0)}"
}

output "aws_security_group_asg_id" {
  value = "${aws_security_group.ecs.id}"
}

output "alb_arn_suffix" {
  value = "${aws_alb.default.arn_suffix}"
}

output "aws_alb_target_group_name" {
  value = "${aws_alb_target_group.default.arn}"
}

output "aws_alb_target_group_arn_suffix" {
  value = "${aws_alb_target_group.default.arn_suffix}"
}

output "aws_asg_name" {
  value = "${aws_autoscaling_group.ecs.name}"
}
