variable "cpus" {
  type    = string
  default = "1"
}

variable "disk_size" {
  type    = string
  default = "7500"
}

variable "domain" {
  type    = string
  default = "tchecode.local"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:45c9feabba213bdc6d72e7469de71ea5aeff73faea6bfb109ab5bad37c3b43bd"
}

variable "iso_file" {
  type    = string
  default = "debian-11.2.0-amd64-netinst.iso"
}

variable "iso_path" {
  type    = string
  default = "http://cdimage.debian.org/cdimage/release/current/amd64/iso-cd"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "preseed_file" {
  type    = string
  default = "debian-11-pt-BR.pkrtpl.hcl"
}

variable "qemu_binary" {
  type    = string
  default = "qemu-system-x86_64"
}

variable "shutdown_timeout" {
  type    = string
  default = "10m"
}

variable "ssh_clear_authorized_keys" {
  type    = string
  default = "false"
}

variable "ssh_fullname" {
  type    = string
  default = "Ops user"
}

variable "ssh_password" {
  type    = string
  default = "tchecode"
}

variable "ssh_timeout" {
  type    = string
  default = "60m"
}

variable "ssh_username" {
  type    = string
  default = "ops"
}

variable "start_retry_timeout" {
  type    = string
  default = "5m"
}

variable "vm_name" {
  type    = string
  default = "debian-bullseye.qcow2"
}

variable "vnc_vrdp_bind_address" {
  type    = string
  default = "127.0.0.1"
}
