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
  most_recent      = true
  owners           = ["amazon"]

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

locals {
  app_server_tags = {
    CreationDate = "${formatdate("DD-MM-YYYY", timestamp())}"
  }
}

resource "aws_instance" "app_server" {
  count         = var.environment == "dev" ? 1 : 2
  ami           = data.aws_ami.ami.image_id
  instance_type = "t2.micro"

  tags = {
    Name         = "Instance ${count.index}"
    CreationDate = local.app_server_tags["CreationDate"]
  }
}
