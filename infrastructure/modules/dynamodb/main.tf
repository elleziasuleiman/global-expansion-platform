resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  hash_key     = var.hash_key
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = var.hash_key
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }
}
