

data "aws_iam_policy_document" "bucket_policy" {

  dynamic "statement" {
    for_each = var.disallow_non_encrypted_uploads ? [1] : []

    content {
      sid       = "DenyIncorrectEncryptionHeader"
      effect    = "Deny"
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.default.arn}/*"]

      principals {
        identifiers = ["*"]
        type        = "*"
      }

      condition {
        test     = "StringNotEquals"
        values   = [var.sse_algorithm]
        variable = "s3:x-amz-server-side-encryption"
      }
    }
  }

  dynamic "statement" {
    for_each = var.disallow_non_encrypted_uploads ? [1] : []

    content {
      sid       = "DenyUnEncryptedObjectUploads"
      effect    = "Deny"
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.default.arn}/*"]

      principals {
        identifiers = ["*"]
        type        = "*"
      }

      condition {
        test     = "Null"
        values   = ["true"]
        variable = "s3:x-amz-server-side-encryption"
      }
    }
  }

  dynamic "statement" {
    for_each = var.disallow_non_ssl_requests ? [1] : []

    content {
      sid       = "ForceSSLOnlyAccess"
      effect    = "Deny"
      actions   = ["s3:*"]
      resources = [aws_s3_bucket.default.arn, "${aws_s3_bucket.default.arn}/*"]

      principals {
        identifiers = ["*"]
        type        = "*"
      }

      condition {
        test     = "Bool"
        values   = ["false"]
        variable = "aws:SecureTransport"
      }
    }
  }

  dynamic "statement" {
    for_each = var.additional_policies

    content {
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      principals {
        identifiers = statement.value.principal_identifiers
        type        = statement.value.principal_type
      }
    }
  }
}

data "aws_iam_policy_document" "aggregated_policy" {
  source_policy_documents   = [var.policy]
  override_policy_documents = [data.aws_iam_policy_document.bucket_policy.json]
}

resource "aws_s3_bucket_policy" "default" {
  bucket     = aws_s3_bucket.default.id
  policy     = data.aws_iam_policy_document.aggregated_policy.json
  depends_on = [aws_s3_bucket_public_access_block.default]
}