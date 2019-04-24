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

// until we get a vpn server set up we are going to use this jump box locked down by ip.
resource "aws_instance" "jump_box" {
  ami                         = "${data.aws_ami.jump_box.image_id}"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.allow_ssh.id}"]
  subnet_id                   = "${element(module.vpc.public_subnets, 0)}"
  key_name                    = "${aws_key_pair.default.key_name}"
  associate_public_ip_address = true

  tags {
    project     = "test"
    environment = "test"
    module_name = "${var.module_name}"
  }
}

resource "aws_security_group" "allow_ssh" {
  description = "Allow all inbound traffic"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.jump_box_allowed_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "default" {
  key_name   = "${var.namespace}-default-${var.module_name}"
  public_key = "${tls_private_key.default.public_key_openssh}"
}

// THIS IS ONLY FOR TESTING! DONT USE THESE KEYS IN PRODUCTION!
resource "tls_private_key" "default" {
  algorithm = "RSA"
}
