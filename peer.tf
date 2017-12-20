resource "aws_iam_role_policy" "peer_dynamo_access" {
  name = "dynamo_access"
  role = "${var.peer_role_id}"

  policy = <<EOF
{"Statement":
 [{"Effect":"Allow",
   "Action":
   ["dynamodb:GetItem", "dynamodb:BatchGetItem", "dynamodb:Scan", "dynamodb:Query"],
   "Resource":"arn:aws:dynamodb:*:${var.aws_account}:table/${aws_dynamodb_table.datomic.name}"}]}
EOF
}

resource "aws_iam_role_policy" "peer_cloudwatch_logs" {
  name = "cloudwatch_logs"
  role = "${var.peer_role_id}"

  policy = <<EOF
{"Version": "2012-10-17",
 "Statement":
 [{"Effect": "Allow",
   "Action":
   ["logs:CreateLogGroup", "logs:CreateLogStream",
    "logs:PutLogEvents", "logs:DescribeLogStreams"],
   "Resource": ["arn:aws:logs:*:*:*"]}]}
EOF
}
