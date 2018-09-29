resource "aws_dynamodb_table" "data_table" {
  name           = "${var.dynamodb_name}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "${lookup(var.dynamodb_struct[0], "name")}"
  attribute      = "${var.dynamodb_struct}"
}

resource "aws_dynamodb_table_item" "item_1" {
  table_name = "${aws_dynamodb_table.data_table.name}"
  hash_key   = "${aws_dynamodb_table.data_table.hash_key}"

  item = <<ITEM
{
  "ID": {"S": "1"},
  "Name": {"S": "John"},
  "Surname": {"S": "Doe"},
  "Org": {"S": "Amazon"}
}
ITEM
}

resource "aws_dynamodb_table_item" "item_2" {
  table_name = "${aws_dynamodb_table.data_table.name}"
  hash_key   = "${aws_dynamodb_table.data_table.hash_key}"

  item = <<ITEM
{
  "ID": {"S": "2"},
  "Name": {"S": "Will"},
  "Surname": {"S": "Smith"},
  "Org": {"S": "Microsoft"}
}
ITEM
}
