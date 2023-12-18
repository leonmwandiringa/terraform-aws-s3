# AWS S3 Terraform module

Terraform module built for Vodacom internal use by the Vodasure team.

S3 configurations includes:

- S3 Bucket creation
- TLS Settings
- Metrics Feature
- Global public objects setting
- SSL enforment
- Encyrption at rest
- Lifecycle rules
- Versioning
- Logging
- Object Locking

## Basic Usage

```hcl
module "s3" {
  source = "vodasure/s3"
  bucket_name = var.bucket_name
  tags   = var.global_tags
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0.0 |

## Modules

No Modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tags | (Required) module global tags. | `object({Name = string, Author = string, Environment = string, Provisioner = string, Region = string, Project = string, SecurityZone = string, TaggingVersion = string, BusinessService = string, Confidentiality = string})` | `null` | yes |
| acl | (Optional) bucket access control list. | `string` | `null` | no |
| policy | (Optional) an additional bucket policy string to current ones. | `string` | `null` | no |
| force_destroy | (Optional) Force destroying of bucket. | `bool` | `false` | no |
| versioning_enabled | (Optional) Force destroying of bucket. | `bool` | `true` | no |
| logging | (Optional) Bucket access logging bucket params. | `list(object({bucket_id = string, prefix = string}))` | `null` | no |
| sse_algorithm | (Optional) Bucket serverside on rest encryption. | `string` | `AES256` | no |
| kms_master_key_arn | (Optional) kms master key arn if sse_encryption of kms is selected. | `string` | `""` | no |
| allowed_bucket_actions | (Optional) Allowed bucket actions api list. | `list(string)` | `["s3:PutObject", "s3:PutObjectAcl", "s3:GetObject", "s3:DeleteObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:GetBucketLocation", "s3:AbortMultipartUpload"]` | no |
| disallow_non_encrypted_uploads | (Optional) encryption at rest enforcement. | `bool` | `true` | no |
| disallow_non_ssl_requests | (Optional) enforce encryption in transit. | `bool` | `true` | no |
| lifecycle_rules | (Optional) Bucket Lifecyle rules. | `list(object({prefix  = string, enabled = bool, tags = map(string), enable_glacier_transition = bool, enable_deeparchive_transition = bool, enable_standard_ia_transition = bool, enable_current_object_expiration = bool, abort_incomplete_multipart_upload_days = number, noncurrent_version_glacier_transition_days = number, noncurrent_version_deeparchive_transition_days = number, noncurrent_version_expiration_days = number, standard_transition_days  = number, glacier_transition_days = number, deeparchive_transition_days = number, expiration_days = number}))` | `[{enabled = false, prefix  = "", tags = {}, enable_glacier_transition = true, enable_deeparchive_transition = false, enable_standard_ia_transition = false, enable_current_object_expiration = true, abort_incomplete_multipart_upload_days = 90, noncurrent_version_glacier_transition_days = 30, noncurrent_version_deeparchive_transition_days = 60, noncurrent_version_expiration_days = 90, standard_transition_days = 30, glacier_transition_days = 60, deeparchive_transition_days = 90, expiration_days = 90}]` | no |
| abort_incomplete_multipart_upload_days | (Optional) Time multiparts are kept while still in progress. | `number` | `5` | no |
| block_public_acls | (Optional) enforce public allowance of access to bucket. | `bool` | `true` | no |
| block_public_policy | (Optional) block public bucket policy addition. | `bool` | `true` | no |
| additional_policies | (Optional) adding custom bucket policies to bucket. | `list(object({effect = string, actions = list(string), resources = list(string), principal_type = string, principal_identifiers = list(string)}))` | `null` | no |
| ignore_public_acls | (Optional) ignore public acl creation or addition. | `bool` | `true` | no |
| restrict_public_buckets | (Optional) restrict public buckets creation. | `bool` | `true` | no |
| bucket_name | (Required) unique bucket name. | `string` | `null` | no |
| object_lock_configuration | (Optional) Object locking feature. | `type = object({mode  = string, days  = number, years = number})` | `null` | no |
| transfer_acceleration_enabled | (Optional) s3 transfer acceleration enablement. | `bool` | `false` | no |
| bucket_metrics_enabled | (Optional) enable bucket metrics. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_domain\_name | fqdn bucket name. |
| bucket\_regional\_domain\_name | bucket regional s3 domain name. |
| bucket\_id | Bucket id. |
| bucket\_arn | Bucket arn. |
| bucket\_region | Bucket region. |

## Authors

Module authored and managed by [Leon_Mwandiringa](https://github.com/leonmwandiringa) from the [Vodasure Team].

## License

Apache 2 Licensed. See LICENSE for full details.
