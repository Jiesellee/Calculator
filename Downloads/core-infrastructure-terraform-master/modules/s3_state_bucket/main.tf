variable "project_name" {
  description = "name of the project"
}

variable "environment" {
  description = "the environment this bucket is used for"
}

variable "namespace_prefix" {
  type        = "string"
  description = "a prefix for the namespace"
  default     = ""
}

locals {
  namespace = "${
    var.namespace_prefix == "" ?
    format("%s-%s", var.environment, var.project_name) : 
    format("%s-%s-%s", var.namespace_prefix, var.environment, var.project_name)
  }"
}

variable "delegated_access_account_ids" {
  type        = "map"
  description = "Account IDs allowed to read the remote state bucket"

  default = {
    dummy = "556748783639"
  }
}

variable "bucket_purpose" {
  type        = "string"
  description = "purpose for the bucket"
  default     = "tf-state"
}

variable "force_destroy_s3_bucket" {
  type        = "string"
  description = "Flag that marks the bucket as destroy-able for terraform, even if the bucket is not empty."
  default     = false
}

resource "aws_s3_bucket" "bucket" {
  // WARNING: if you edit the bucket name, be sure to edit the policy document to match otherwise it will error!
  bucket        = "${local.namespace}-${var.bucket_purpose}" // read the above warning!
  acl           = "private"
  force_destroy = "${var.force_destroy_s3_bucket}"

  versioning {
    enabled = true
  }

  policy = "${data.aws_iam_policy_document.s3_bucket.json}"

  lifecycle_rule {
    prefix  = "/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

  tags {
    Name         = "Terraform State File Bucket"
    environment  = "${var.environment}"
    project_name = "${var.project_name}"
  }
}

data "aws_iam_policy_document" "s3_bucket" {
  statement {
    effect = "Allow"

    principals = {
      type        = "AWS"
      identifiers = ["${formatlist("arn:aws:iam::%s:root", values(var.delegated_access_account_ids))}"]
    }

    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "arn:aws:s3:::${local.namespace}-${var.bucket_purpose}",
      "arn:aws:s3:::${local.namespace}-${var.bucket_purpose}/*",
    ]
  }
}

output "bucket_name" {
  value = "${aws_s3_bucket.bucket.id}"
}
