variable "vms" {
  type = list(object({
    name     = string
    memory   = number
    vcpu     = number
    password = string
  }))
}

variable "host" {
  type = string
  default = "qemu:///system"
}