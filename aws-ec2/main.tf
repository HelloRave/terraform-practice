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

locals {
  app_server_tags = {
    CreationDate = "${formatdate("DD-MM-YYYY", timestamp())}"
  }
}

resource "aws_instance" "app_server" {
  count         = var.environment == "dev" ? 1 : 2
  ami           = var.ami
  instance_type = "t2.micro"

  tags = {
    Name         = "Instance ${count.index}"
    CreationDate = local.app_server_tags["CreationDate"]
  }
}
