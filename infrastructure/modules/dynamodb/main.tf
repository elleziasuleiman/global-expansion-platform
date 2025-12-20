data "aws_caller_identity" "current" {}

resource "aws_kms_key" "dynamo" {
  description             = var.kms_key_description
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags                    = var.tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action = "kms:*"
        Resource = "*"
      }
    ]
  })
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
    kms_key_arn        = aws_kms_key.dynamo.arn
  }

  point_in_time_recovery {
    enabled = true
  }
}
