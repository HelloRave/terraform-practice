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

resource "aws_instance" "app_server" {
  count         = var.environment == "dev" ? 1 : 2
  ami           = var.ami
  instance_type = "t2.micro"

  tags = {
    Name = "Instance ${count.index}"
  }
}
