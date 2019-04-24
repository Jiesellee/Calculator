resource "aws_s3_bucket" "versions" {
  bucket = "${var.project_name}-${var.environment}-concourse-versions"
  acl    = "private"

  tags {
    Name         = "${var.project_name}-${var.environment}-concourse-versions"
    project_name = "${var.project_name}"
    environment  = "${var.environment}"
  }
}
