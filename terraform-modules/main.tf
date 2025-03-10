provider "aws" {
  region = "ap-southeast-1"
}

module "ec2" {
  source = "github.com/zealvora/sample-kplabs-terraform-ec2-module"
}

module "ec2_2" {
  source        = "./modules/ec2"
  ami           = "ami-0b03299ddb99998e9"
  instance_type = "t2.micro"
}

resource "aws_vpc_security_group_ingress_rule" "http_port" {
  security_group_id = module.ec2_2.security_group_id
  cidr_ipv4         = var.vpn_ip
  from_port         = var.http_port
  ip_protocol       = "tcp"
  to_port           = var.http_port
}
