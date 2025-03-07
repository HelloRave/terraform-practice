provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "app_server" {
  for_each      = var.ami
  ami           = each.value
  instance_type = "t2.micro"
}

output "servers_arn" {
  value = aws_instance.app_server["dev"].arn
}