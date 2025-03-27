output "Secret_bucket" {
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.bucket.bucket}/${var.bucket_image_key}"
  description = "URL for secret bucket"
}

output "Static_HTML_over_HTTPS" {
  value       = "https://${yandex_storage_bucket.bucket-html.bucket}.website.yandexcloud.net"
  description = "URL for static web-bucket"
}
