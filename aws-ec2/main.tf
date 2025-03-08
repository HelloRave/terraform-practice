terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.89.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20250220.0-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_key_pair" "ec2_ssh_key" {
  filter {
    name   = "key-name"
    values = ["terraform-key"]
  }
}

locals {
  app_server_tags = {
    CreationDate = "${formatdate("DD-MM-YYYY", timestamp())}"
  }
}

resource "aws_instance" "app_server" {
  count           = var.environment == "dev" ? 2 : 1
  ami             = data.aws_ami.ami.image_id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_tls.name]
  key_name        = data.aws_key_pair.ec2_ssh_key.key_name

  tags = {
    Name         = "Instance ${count.index}"
    CreationDate = local.app_server_tags["CreationDate"]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("./terraform-key.pem")
  }

  provisioner "remote-exec" {
    inline = ["sudo yum -y install httpd", "sudo systemctl start httpd"]
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "terraform-firewall"
  description = "Managed from firewall"
}

resource "aws_vpc_security_group_ingress_rule" "http_port" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.vpn_ip
  from_port         = var.http_port
  ip_protocol       = "tcp"
  to_port           = var.http_port
}

resource "aws_vpc_security_group_ingress_rule" "ssh_port" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.vpn_ip
  from_port         = var.ssh_port
  ip_protocol       = "tcp"
  to_port           = var.ssh_port
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.vpn_ip
  ip_protocol       = "-1" # semantically equivalent to all ports
}

output "app_servers_arn" {
  value = aws_instance.app_server[*].arn
}
