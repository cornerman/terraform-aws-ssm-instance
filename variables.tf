variable "name_prefix" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "root_volume_size_gb" {
  type    = number
  default = 20
}

variable "egress_everywhere" {
  type    = bool
  default = true
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
