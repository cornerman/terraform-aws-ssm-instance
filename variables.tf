variable "name_prefix" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "egress_everywhere" {
  type    = bool
  default = false
}

variable "cloudinit_shellscript" {
  type    = string
  default = ""
}

variable "extra_security_groups" {
  type    = list(string)
  default = []
}

variable "extra_iam_policies" {
  type    = list(string)
  default = []
}
