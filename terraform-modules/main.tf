provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  alias = "usa"
  region = "us-east-1"
}

locals {
  instance_type = {
    default = "t2.micro"
    dev     = "t2.nano"
  }
}

module "ec2" {
  source = "github.com/zealvora/sample-kplabs-terraform-ec2-module"
}

module "ec2_2" {
  source        = "./modules/ec2"
  ami           = "ami-0b03299ddb99998e9"
  instance_type = local.instance_type[terraform.workspace]
}

module "ec2_3" {
  source        = "./modules/ec2"
  providers = {
    aws = aws.usa
  }
  ami           = "ami-08b5b3a93ed654d19"
  instance_type = local.instance_type[terraform.workspace]
}

resource "aws_vpc_security_group_ingress_rule" "http_port" {
  security_group_id = module.ec2_2.security_group_id
  cidr_ipv4         = var.vpn_ip
  from_port         = var.http_port
  ip_protocol       = "tcp"
  to_port           = var.http_port
}
