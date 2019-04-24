// postgres setup

resource "aws_security_group" "rds_concourse" {
  name        = "${var.project_name}-${var.environment}-rds-postgres"
  description = "Allow postgres inbound traffic"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    security_groups = [
      "${aws_security_group.ecs.id}",
    ]
  }
}

resource "aws_db_parameter_group" "concourse" {
  name        = "${var.project_name}-${var.environment}"
  family      = "postgres9.6"
  description = "RDS default parameter group"
}

resource "aws_db_instance" "postgres_concourse" {
  identifier              = "${var.project_name}-${var.environment}"
  allocated_storage       = 10
  engine                  = "postgres"
  engine_version          = "9.6.6"
  instance_class          = "db.t2.medium"
  name                    = "concourse"
  username                = "concourse"
  backup_retention_period = 35
  backup_window           = "00:00-03:00"

  password                  = "${data.aws_kms_secret.postgres.postgres_password}"
  vpc_security_group_ids    = ["${aws_security_group.rds_concourse.id}"]
  db_subnet_group_name      = "${aws_db_subnet_group.default.name}"
  parameter_group_name      = "${aws_db_parameter_group.concourse.name}"
  skip_final_snapshot       = "${var.postgres_skip_final_snapshot}"
  final_snapshot_identifier = "${var.environment}-${var.project_name}-final-snapshot"
  multi_az                  = "${var.postgres_multi_az}"
  snapshot_identifier       = "${var.snapshot_identifier}"
}

resource "aws_db_subnet_group" "default" {
  name        = "${var.project_name}-${var.environment}-main"
  description = "${var.environment} environment main group of subnets"
  subnet_ids  = ["${var.private_subnets}"]

  tags {
    Name = "${var.environment}-${var.project_name}"
  }
}
