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

resource "aws_iam_policy" "policy_one" {
  name   = "test_policy"
  policy = file("./policy.json")
}
