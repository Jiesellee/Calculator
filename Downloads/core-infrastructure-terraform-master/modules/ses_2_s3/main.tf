data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "inbound_emails" {
  bucket        = "${var.project_name}-${var.environment}-ses-2-s3"
  acl           = "private"
  force_destroy = true

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "GiveSESPermissionToWriteEmail",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "ses.amazonaws.com"
                ]
            },
            "Action": [
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::${var.project_name}-${var.environment}-ses-2-s3/*",
            "Condition": {
                "StringEquals": {
                    "aws:Referer": "${data.aws_caller_identity.current.account_id}"
                }
            }
        }
    ]
}
EOF

  tags = "${merge(
            map(
              "Name", "${var.project_name}-${var.environment}-ses-2-s3",
              "environment", "${var.environment}",
              "project_name", "${var.project_name}",
              "terraform", "true"), 
            var.resource_tags)
          }"
}

resource "aws_ses_domain_identity" "inbound_email_domain" {
  domain = "${var.domain != "false" ? var.domain: "${var.environment}.${var.project_name}.ri-tech.io" }"
}

resource "aws_route53_record" "inbound_email_domain" {
  zone_id = "${var.route53_zone_id}"
  name    = "_amazonses.${var.domain != "false" ? var.domain: "${var.environment}.${var.project_name}.ri-tech.io" }"
  type    = "TXT"
  ttl     = "60"
  records = ["${aws_ses_domain_identity.inbound_email_domain.verification_token}"]
}

resource "aws_ses_active_receipt_rule_set" "main" {
  rule_set_name = "${aws_ses_receipt_rule_set.main.rule_set_name}"
}

resource "aws_ses_receipt_rule_set" "main" {
  rule_set_name = "${var.project_name}-${var.environment}-ses-2-s3"
}

resource "aws_ses_receipt_rule" "store" {
  name          = "store"
  rule_set_name = "${aws_ses_receipt_rule_set.main.rule_set_name}"
  recipients    = ["hostmaster@${var.domain != "false" ? var.domain: "${var.environment}.${var.project_name}.ri-tech.io" }"]
  enabled       = true
  scan_enabled  = false

  s3_action {
    bucket_name = "${aws_s3_bucket.inbound_emails.bucket}"
    position    = 0
  }
}

resource "aws_route53_record" "inbound_email_mx" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.domain != "false" ? var.domain: "${var.environment}.${var.project_name}.ri-tech.io" }"
  type    = "MX"
  ttl     = "60"
  records = ["10 inbound-smtp.eu-west-1.amazonaws.com"]
}
