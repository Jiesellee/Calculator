data "aws_ami" "jump_box" {
  most_recent = true

  filter {
    name = "name"

    # debian
    # https://wiki.debian.org/Cloud/AmazonEC2Image/Stretch
    values = ["debian-stretch-hvm-x86_64-gp2-*"]
  }

  //debian owner id
  owners = ["379101102735"]
}

// simple micro instance jump box.
resource "aws_instance" "jump_box" {
  ami                         = "${data.aws_ami.jump_box.image_id}"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.allow_ssh.id}"]
  subnet_id                   = "${var.subnet}"
  key_name                    = "${var.ssh_key_name}"
  associate_public_ip_address = "${var.public}"

  tags {
    Name        = "${var.project_name}-${var.environment}-jump-box"
    project     = "${var.project_name}"
    environment = "${var.environment}"
    terraform   = true
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "${var.environment}-allow-ssh"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"
}

// the box needs internet access for ntp etc.
resource "aws_security_group_rule" "allow_all_outbound" {
  type        = "egress"
  from_port   = 1
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.allow_ssh.id}"
}

// allow ssh access to a specific ip if its set
resource "aws_security_group_rule" "allow_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${var.jump_box_allowed_range}"]

  security_group_id = "${aws_security_group.allow_ssh.id}"

  count = "${var.jump_box_allowed_range_enable ? 1 : 0 }"
}
