variable "acl" {
  type        = string
  default     = "private"
  description = "The [canned ACL] conflicts with grants, nullified when grants in use"
}

variable "policy" {
  type        = string
  default     = ""
  description = "A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan. In this case, please make sure you use the verbose/specific version of the policy"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "A boolean string that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable"
}

variable "versioning_enabled" {
  type        = bool
  default     = true
  description = "A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket"
}

variable "logging" {
  type = list(object({
    bucket_id = string
    prefix    = string
  }))
  default = null
  description = "Bucket access logging configuration."
}

variable "website_configuration" {
  type = object({
    index_document = string
    error_document = string
  })
}
variable "iswebsite" {
  type = bool
  default = false
  description = "website bool"
}

variable "sse_algorithm" {
  type        = string
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are `AES256` and `aws:kms`"
}

variable "kms_master_key_arn" {
  type        = string
  default     = ""
  description = "The AWS KMS master key ARN used for the `SSE-KMS` encryption. This can only be used when you set the value of `sse_algorithm` as `aws:kms`. The default aws/s3 AWS KMS master key is used if this element is absent while the `sse_algorithm` is `aws:kms`"
}

variable "allowed_bucket_actions" {
  type        = list(string)
  default     = ["s3:PutObject", "s3:PutObjectAcl", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:GetBucketLocation", "s3:AbortMultipartUpload"]
  description = "List of actions the user is permitted to perform on the S3 bucket"
}

variable "disallow_non_encrypted_uploads" {
  type        = bool
  default = true
  description = "Set to `true` to prevent uploads of unencrypted objects to S3 bucket"
}

variable "disallow_non_ssl_requests" {
  type        = bool
  default = true
  description = "Set to `true` to require requests to use Secure Socket Layer (HTTPS/SSL). This will explicitly deny access to HTTP requests"
}

variable "lifecycle_rules" {
  type = list(object({
    prefix  = string
    enabled = bool
    tags    = map(string)

    enable_glacier_transition        = bool
    enable_deeparchive_transition    = bool
    enable_standard_ia_transition    = bool
    enable_current_object_expiration = bool

    abort_incomplete_multipart_upload_days         = number
    noncurrent_version_glacier_transition_days     = number
    noncurrent_version_deeparchive_transition_days = number
    noncurrent_version_expiration_days             = number

    standard_transition_days    = number
    glacier_transition_days     = number
    deeparchive_transition_days = number
    expiration_days             = number
  }))
  default = [{
    enabled = false
    prefix  = ""
    tags    = {}

    enable_glacier_transition        = true
    enable_deeparchive_transition    = false
    enable_standard_ia_transition    = false
    enable_current_object_expiration = true

    abort_incomplete_multipart_upload_days         = 90
    noncurrent_version_glacier_transition_days     = 30
    noncurrent_version_deeparchive_transition_days = 60
    noncurrent_version_expiration_days             = 90

    standard_transition_days    = 30
    glacier_transition_days     = 60
    deeparchive_transition_days = 90
    expiration_days             = 90
  }]
  description = "A list of lifecycle rules"
}

variable "abort_incomplete_multipart_upload_days" {
  type        = number
  default     = 5
  description = "Maximum time (in days) that you want to allow multipart uploads to remain in progress"
}

variable "additional_policies" {
  type = list(object({
    effect = string
    actions = list(string)
    resources = list(string)
    principal_type = string
    principal_identifiers = list(string)
  }))
  description = "additional bucket policies"
  default = []
}

variable "block_public_acls" {
  type        = bool
  default     = true
  description = "Set to `false` to disable the blocking of new public access lists on the bucket"
}

variable "block_public_policy" {
  type        = bool
  default     = true
  description = "Set to `false` to disable the blocking of new public policies on the bucket"
}

variable "ignore_public_acls" {
  type        = bool
  default     = true
  description = "Set to `false` to disable the ignoring of public access lists on the bucket"
}

variable "restrict_public_buckets" {
  type        = bool
  default     = true
  description = "Set to `false` to disable the restricting of making the bucket public"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name. If provided, the bucket will be created with this name instead of generating the name from the context"
}

variable "object_lock_configuration" {
  type = object({
    mode  = string # Valid values are GOVERNANCE and COMPLIANCE.
    days  = number
    years = number
  })
  default     = null
  description = "A configuration for S3 object locking. With S3 Object Lock, you can store objects using a `write once, read many` (WORM) model. Object Lock can help prevent objects from being deleted or overwritten for a fixed amount of time or indefinitely."
}

variable "transfer_acceleration_enabled" {
  type        = bool
  default     = false
  description = "Set this to true to enable S3 Transfer Acceleration for the bucket."
}

variable "tags" {
  type = object({
    Name = string
    Author      = string
    Environment = string
    Provisioner = string
    Region      = string
  })
  description = "base tags required in every resource"
}

variable "bucket_metrics_enabled" {
  type        = bool
  default = false
  description = "boolean to enable or disable bucket wide metrics"
}
