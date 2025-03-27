#######################################
# Yandex.cloud BUCKET
#######################################
bucket_name                     = "myfirstbucket"
bucket_file_key                 = "index.html"
bucket_file                     = "../data/index.html"
bucket_image_key                = "image.png"
bucket_image                    = "../data/image.png"
bucket_encryption_key_algorithm = "AES_256"

#######################################
# Yandex.cloud HTTPS on BUCKET
#######################################
cert_name    = "cats-cert"
cert_domains = ["example.com"]

bucket_html_name       = "static-html"
bucket_html_index_file = "../data/index.html"