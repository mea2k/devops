#######################################
# 1. Создание бакета Object Storage
#######################################
## KMS_KEY
resource "yandex_kms_symmetric_key" "bucket_key" {
  name              = var.bucket_encryption_key_name
  default_algorithm = var.bucket_encryption_key_algorithm
  rotation_period   = var.bucket_encryption_key_rotation
  description       = "KMS key for encrypting bucket content"
  # Настройки прав доступа
  lifecycle {
    create_before_destroy = true
  }
}

## Статический ключ доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = var.service_account_id
  description        = "static access key for object storage"
}

## BUCKET
resource "yandex_storage_bucket" "bucket" {
  bucket     = "${var.bucket_name}-${formatdate("YYYYMMDD", timestamp())}"
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
  anonymous_access_flags {
    read = true
  }
  # удаляем, даже если не пустой
  force_destroy = true
}

## Загрузка файла в бакет
resource "yandex_storage_object" "content" {
  bucket     = yandex_storage_bucket.bucket.bucket
  key        = var.bucket_file_key
  source     = var.bucket_file
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
}
## Загрузка картинки в бакет
resource "yandex_storage_object" "image" {
  bucket     = yandex_storage_bucket.bucket.bucket
  key        = var.bucket_image_key
  source     = var.bucket_image
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
}



#######################################
# 2. Создание защищенного (HTTPS) сайта 
#    на основе Object Storage
#######################################
## new self-managed certificate for specific Domain name
resource "yandex_cm_certificate" "cert" {
  name = var.cert_name
  #domains = var.cert_domains

  self_managed {
    certificate = var.cert_certificate
    private_key = var.cert_private_key
  }
}

## Bucket for static HTML
resource "yandex_storage_bucket" "bucket-html" {
  bucket = "${var.bucket_html_name}-${formatdate("YYYYMMDD", timestamp())}"
  anonymous_access_flags {
    read = true
  }
  # привязка ранее созданного сертификата
  https {
    certificate_id = yandex_cm_certificate.cert.id
  }
  # политика доступа
  acl = "public-read"
  # настройка сайта
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  # удаляем, даже если не пустой
  force_destroy = true
}
## Загрузка index.html в бакет
resource "yandex_storage_object" "index" {
  bucket = yandex_storage_bucket.bucket-html.bucket
  key    = "index.html"
  source = var.bucket_html_index_file
}
