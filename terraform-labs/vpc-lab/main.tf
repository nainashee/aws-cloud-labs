terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"

        }
    }
}

provider "aws" {
  region = "us-east-1"
}   

resource "aws_vpc" "practice_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_internet_gateway" "vpc_IGW"  {
  vpc_id = aws_vpc.practice_vpc.id

  tags = {
    Name = "aws_IGW"
  }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.practice_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-west-1c"

    tags = {
        Name = "practice_subnet"
    }
}

resource "aws_route_table" "practice_routetable" {
  vpc_id = aws_vpc.practice_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_IGW.id
  }

  tags = {
    Name = "practice_routetable"
  }
}

resource "aws_route_table_association" "route_table_assiciation" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.practice_routetable.id
}