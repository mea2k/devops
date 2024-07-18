variable "yc_iam_token" {
  description = "Yandex Cloud authorization token. Use 'yc iam create-token' to receive"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID. Use 'yc resource-manager cloud list' and 'yc resource-manager cloud get <cloud_name>' to receive"
  type        = string
  sensitive   = true
}

variable "yc_folder_id" {
  description = "Yandex Folder ID. Use 'yc resource-manager folder list' and 'yc resource-manager folder get <folder_name>' to receive"
  type        = string
  sensitive   = true
}

variable "yc_zone" {
  description = "Yandex Zone. Use 'yc config list' to receive"
  type        = string
  sensitive   = true
}

variable "yc_organization_id" {
  description = "Yandex Ogranization ID. Use 'yc organization-manager organization list' to receive"
  type        = string
  sensitive   = true
}
