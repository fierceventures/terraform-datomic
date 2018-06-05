output "dynamo_arn" {
	value = "${aws_dynamodb_table.datomic.arn}"
}