terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.90.0"
    }

  }
}

resource "aws_instance" "app_server" {
  ami           = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.allow_tls.name]
}

resource "aws_security_group" "allow_tls" {
  name        = "terraform-firewall"
  description = "Managed from firewall"
}

output "security_group_id" {
  value = aws_security_group.allow_tls.id
}
