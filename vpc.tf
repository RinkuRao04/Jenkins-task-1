terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "vpc1" {
  cidr_block       = "10.0.0.0/24
  instance_tenancy = "default"
  tags = {
      Name = "VPC-For-Web-Hosting"
  }

}

resource "aws_subnet" "subnet1a" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = "true"
  tags = {
      Name = "subnet-For-Web-Hosting"
  }
}

resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "igw-For-Web-Hosting"
  }
}

resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1_igw.id
  }

  tags = {
    Name = "default_route_table_association"
  }
}

resource "aws_route_table_association" "subnet1a_rt" {
  subnet_id      = aws_subnet.subnet1a.id
  route_table_id = aws_route_table.Public_RT.id
}


resource "aws_instance" "EC2-1" {
  ami                    = "ami-01811d4912b4ccb26"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet1a
  vpc_security_group_ids = [aws_security_group.Security-group.id]
  tags = {
    Name = "jenkins-1-ec2"
  }
  associate_public_ip_address = true
}

resource "aws_security_group" "Security-group" {
  name   = "SG-For-Web-Hosting"
  vpc_id = aws_vpc.vpc1.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}


