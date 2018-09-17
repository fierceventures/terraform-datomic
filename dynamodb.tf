resource "aws_dynamodb_table" "datomic" {
  name = "${terraform.workspace}-${var.namespace}"
  read_capacity = "${var.dynamo_read_capacity}"
  write_capacity = "${var.dynamo_write_capacity}"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  lifecycle {
    prevent_destroy = false
  }
}
