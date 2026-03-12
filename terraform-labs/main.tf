terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}


resource "aws_instance" "practice_ec2" {
  ami           = "ami-0d53d72369335a9d6"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0acf43f8538b5a022"

  tags = {
    Name = "terraform-practice-ec2"
  }
}