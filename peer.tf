resource "aws_iam_role_policy" "peer_dynamo_access" {
  name   = "${terraform.workspace}_${var.namespace}_dynamo_access"
  role   = "${var.peer_role_id}"

  policy = <<EOF
{"Statement":
 [{"Effect":"Allow",
   "Action":
   ["dynamodb:GetItem", "dynamodb:BatchGetItem", "dynamodb:Scan", "dynamodb:Query"],
   "Resource":"arn:aws:dynamodb:*:${var.aws_account}:table/${aws_dynamodb_table.datomic.name}"}]}
EOF
}
