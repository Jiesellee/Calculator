output "vpc_cidr" {
  value = "10.${var.cidr_namespace}.0.0/16"
}

output "vpc_private_subnets" {
  value = ["${module.vpc.private_subnets}"]
}

output "vpc_public_subnets" {
  value = ["${module.vpc.public_subnets}"]
}

output "vpc_vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_public_route_table_ids" {
  value = ["${module.vpc.public_route_table_ids}"]
}

output "vpc_private_route_table_ids" {
  value = ["${module.vpc.private_route_table_ids}"]
}

output "vpc_default_security_group_id" {
  value = "${module.vpc.default_security_group_id}"
}

output "vpc_nat_eips" {
  value = ["${module.vpc.nat_public_ips}"]
}

output "vpc_nat_eips_public_ips" {
  value = ["${module.vpc.nat_public_ips}"]
}

output "vpc_natgw_ids" {
  value = ["${module.vpc.natgw_ids}"]
}

output "vpc_igw_id" {
  value = "${module.vpc.igw_id}"
}

output "zone_id" {
  value = "${aws_route53_zone.default.zone_id}"
}

// jumpbox.tf

output "aws_key_pair_key_name" {
  value = "${aws_key_pair.default.key_name}"
}

output "jump_box_ip" {
  value = "${aws_instance.jump_box.public_ip}"
}

output "aws_key_pair_private_key" {
  value = "${tls_private_key.default.private_key_pem}"
}

output "aws_security_group" {
  value = "${aws_security_group.allow_ssh.id}"
}
