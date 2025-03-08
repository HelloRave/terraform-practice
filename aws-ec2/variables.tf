variable "environment" {
  default = "dev"
}

variable "ami" {
  default     = "ami-0b03299ddb99998e9"
  description = "AMI for Singapore Region"
}

variable "vpn_ip" {
  default = "0.0.0.0/0"
}

variable "ssh_port" {
  default = 22
}

variable "http_port" {
  default = 80
}