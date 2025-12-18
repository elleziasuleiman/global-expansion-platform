resource "aws_kms_key" "dynamo" {
  description             = var.kms_key_description
  deletion_window_in_days = 30
  tags                    = var.tags
}

resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  hash_key     = var.hash_key
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = var.hash_key
    type = "S"
  }

  server_side_encryption {
    enabled            = true
    kms_master_key_id  = aws_kms_key.dynamo.arn
  }

  point_in_time_recovery {
    enabled = true
  }
}
