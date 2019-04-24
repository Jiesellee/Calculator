resource "aws_iam_role" "batch_service_role" {
  name = "batch_service_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
	  "Action": "sts:AssumeRole",
	  "Effect": "Allow",
	  "Principal": {
	  "Service": "batch.amazonaws.com"
	  }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "batch_service_role" {
  role       = "${aws_iam_role.batch_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}
