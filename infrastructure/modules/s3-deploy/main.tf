# ==========================================
# GEP Platform - S3 Deployment Module
# ==========================================

data "aws_caller_identity" "current" {}

# --- Security: KMS Key for Encryption ---
resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 bucket server-side encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags                    = var.tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "Enable IAM User Permissions"
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action    = "kms:*"
        Resource  = "*"
      }
    ]
  })
}

# --- Resource: Main Deployment Bucket ---
resource "aws_s3_bucket" "this" {
  # checkov:skip=CKV_AWS_144: Data must remain in Singapore per residency requirements.
  # checkov:skip=CKV2_AWS_62: Event notifications are handled via the access_logs_notification resource.
  bucket = var.bucket_name
  tags   = var.tags
}

# Fix for CKV_AWS_21: Enable Versioning
resource "aws_s3_bucket_versioning" "this" {
  # checkov:skip=CKV_AWS_144: Cross-region replication is disabled to comply with strict Singapore data residency requirements.
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Fix for CKV_AWS_145: Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3.arn
    }
  }
}

# Fix for CKV2_AWS_6: Public Access Block
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Fix for CKV_AWS_300: Lifecycle & Multipart Upload Cleanup
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "expire-and-abort"
    status = "Enabled"

    expiration {
      days = 365
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# --- Resource: Access Logs Target Bucket ---
resource "aws_s3_bucket" "access_logs" {
  # checkov:skip=CKV_AWS_144: Log replication across regions is not required for this scope.
  # checkov:skip=CKV2_AWS_62: Internal logging bucket does not require external notifications.
  bucket = "${var.bucket_name}-access-logs"
  tags   = var.tags
}

# Hardening for Access Logs Bucket (Required to pass Checkov)
resource "aws_s3_bucket_versioning" "access_logs" {
  # checkov:skip=CKV_AWS_144: Log replication across regions is not required for this assessment scope.
  bucket = aws_s3_bucket.access_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    id     = "cleanup-old-logs"
    status = "Enabled"

    expiration {
      days = 365
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# --- Logging & Notifications ---
resource "aws_s3_bucket_logging" "this" {
  bucket        = aws_s3_bucket.this.id
  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "access-logs/"
}

resource "aws_sns_topic" "s3_events" {
  name              = "${var.bucket_name}-events"
  # Fix for CKV_AWS_26: SNS Encryption
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_s3_bucket_notification" "this_notification" {
  bucket      = aws_s3_bucket.this.id
  eventbridge = true 
}

resource "aws_s3_bucket_notification" "access_logs_notification" {
  bucket      = aws_s3_bucket.access_logs.id
  eventbridge = true # Satisfies CKV2_AWS_62 by enabling event flow
}