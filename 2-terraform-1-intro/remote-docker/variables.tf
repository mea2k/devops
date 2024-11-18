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

variable "yc_user_id" {
  description = "Yandex User ID. Use 'yc organization-manager user list --organization-id <yc_organization_id>' to receive"
  type        = string
  sensitive   = true
}


variable "yc_public_key_ubuntu" {
  description = "Public Key for VMs via OS Login (from Ubuntu VM Controller) - the same as in 'user-data'"
  type        = string
  sensitive   = true
}

variable "yc_public_key_win" {
  description = "Public Key for VMs via OS Login (from Windows Host) - the same as in 'user-data'"
  type        = string
  sensitive   = true
}

variable "ssh_user" {
  description = "SSH User for connect - the same as in 'user-data'"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "DB user for MySQL (default: wordpress)"
  type        = string
  sensitive   = false
  default     = "wordpress"
}