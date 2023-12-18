
resource "aws_s3_bucket" "default" {
  bucket = var.bucket_name
  acl                 = var.acl
  force_destroy       = var.force_destroy
  tags                = var.tags
  acceleration_status = var.transfer_acceleration_enabled ? "Enabled" : null

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      enabled                                = lifecycle_rule.value.enabled
      prefix                                 = lifecycle_rule.value.prefix
      tags                                   = lifecycle_rule.value.tags
      abort_incomplete_multipart_upload_days = lifecycle_rule.value.abort_incomplete_multipart_upload_days

      noncurrent_version_expiration {
        days = lifecycle_rule.value.noncurrent_version_expiration_days
      }

      dynamic "noncurrent_version_transition" {
        for_each = lifecycle_rule.value.enable_glacier_transition ? [1] : []

        content {
          days          = lifecycle_rule.value.noncurrent_version_glacier_transition_days
          storage_class = "GLACIER"
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lifecycle_rule.value.enable_deeparchive_transition ? [1] : []

        content {
          days          = lifecycle_rule.value.noncurrent_version_deeparchive_transition_days
          storage_class = "DEEP_ARCHIVE"
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value.enable_glacier_transition ? [1] : []

        content {
          days          = lifecycle_rule.value.glacier_transition_days
          storage_class = "GLACIER"
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value.enable_deeparchive_transition ? [1] : []

        content {
          days          = lifecycle_rule.value.deeparchive_transition_days
          storage_class = "DEEP_ARCHIVE"
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value.enable_standard_ia_transition ? [1] : []

        content {
          days          = lifecycle_rule.value.standard_transition_days
          storage_class = "STANDARD_IA"
        }
      }

      dynamic "expiration" {
        for_each = lifecycle_rule.value.enable_current_object_expiration ? [1] : []

        content {
          days = lifecycle_rule.value.expiration_days
        }
      }
    }
  }

  dynamic "logging" {
    for_each = var.logging == null ? [] : var.logging
    content {
      target_bucket = logging.value.bucket_id
      target_prefix = logging.value.prefix
    }
  }


  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
        kms_master_key_id = var.kms_master_key_arn
      }
    }
  }

  dynamic "object_lock_configuration" {
    for_each = var.object_lock_configuration != null ? [1] : []
    content {
      object_lock_enabled = "Enabled"
      rule {
        default_retention {
          mode  = var.object_lock_configuration.mode
          days  = var.object_lock_configuration.days
          years = var.object_lock_configuration.years
        }
      }
    }
  }

}
