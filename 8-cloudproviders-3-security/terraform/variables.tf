#######################################
# Yandex.cloud SECRET VARS
#######################################
## token
variable "token" {
  type        = string
  description = "OAuth-token 'yc iam create-token' (https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token)"
}
## cloud id
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}
## cloud-folder id
variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}
## service_account id
variable "service_account_id" {
  type        = string
  description = "'yc iam service-account list'"
}

#######################################
# Yandex.cloud DEFAULTS
#######################################
## default network zone (used in yandex_vpc_subnet) - 'ru-central1-a'
variable "default_zone" {
  type        = string
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
  default     = "ru-central1-a"
}
## default cidr
variable "default_cidr" {
  type        = list(string)
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
  default     = ["10.0.1.0/24"]
}

#######################################
# Yandex.cloud BUCKET
#######################################
## bucket name
variable "bucket_name" {
  type        = string
  description = "Bucket name to create"
}
## bucket file key
variable "bucket_file_key" {
  type        = string
  description = "Bucket key"
  default     = ""
}
## bucket file
variable "bucket_file" {
  type        = string
  description = "Bucket filename"
  default     = ""
}
## bucket image key
variable "bucket_image_key" {
  type        = string
  description = "Bucket key"
}
## bucket image file
variable "bucket_image" {
  type        = string
  description = "Bucket filename"
}

## bucket encryption key name
variable "bucket_encryption_key_name" {
  type        = string
  description = "KMS key for encrypting bucket content"
  default     = "bucket-encryption-key"
}
## bucket encryption algorithm
variable "bucket_encryption_key_algorithm" {
  type        = string
  description = "Bucket encryption algorithm"
}
## bucket encryption key rotation
variable "bucket_encryption_key_rotation" {
  type        = string
  description = "Bucket encryption algorithm"
  default     = "8760h" # Ротация ключа каждые 365 дней
}


#######################################
# Yandex.cloud HTTPS on BUCKET
#######################################
## CERT name
variable "cert_name" {
  type        = string
  description = "HTTPS cert name"
  default     = "my_cert"
}
## CERT domains
variable "cert_domains" {
  type        = list(string)
  description = "list of domains for cert"
}
## CERT Certificate (public)
variable "cert_certificate" {
  type        = string
  description = "-----BEGIN CERTIFICATE----- ... -----END CERTIFICATE----- \n -----BEGIN CERTIFICATE----- ... -----END CERTIFICATE-----"
}
## CERT Private Key (private)
variable "cert_private_key" {
  type        = string
  description = "-----BEGIN RSA PRIVATE KEY----- ... -----END RSA PRIVATE KEY-----"
}

## Bucket name for static HTML
variable "bucket_html_name" {
  type        = string
  description = "Bucket name for Static HTML"
}
## Bucket static HTML index page source
variable "bucket_html_index_file" {
  type        = string
  description = "Bucket static HTML index page source"
}