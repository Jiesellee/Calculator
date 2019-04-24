{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": "arn:aws:dynamodb:${ region }:*:table/${ project_name }-${ environment }-vault-table"
    }
  ]
}