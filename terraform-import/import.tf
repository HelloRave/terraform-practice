provider "aws" {
  region = "ap-southeast-1"
}

import {
  to = aws_security_group.my_security_group
  id = "sg-0a8f0dc961e37e27a"
}