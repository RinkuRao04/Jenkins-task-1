resource "aws_vpc" "vpc_tf" {
  cidr_block       = "10.1.0.0/24"
  instance_tenancy = "default"

  tags = {
    Name = "VPC-for-hosting"
  }
}

resource "aws_subnet" "public-subnet_tf" {
  vpc_id     = aws_vpc.vpc_tf.id
  cidr_block = "10.1.0.0/26"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "PUBLIC-SUBNET-for-hosting"
  }
  depends_on = [aws_vpc.vpc_tf]
}


resource "aws_internet_gateway" "igw_tf" {
  vpc_id = aws_vpc.vpc_tf.id
  tags = {
    Name = "IGW-for-hosting"
  }
  depends_on = [aws_vpc.vpc_tf]
}

resource "aws_eip" "eip_tf" {}


resource "aws_route_table" "public-rt_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_tf.id
  }

  tags = {
    Name = "PUBLIC_RT-for-hosting"
  }
  depends_on = [aws_vpc.vpc_tf, aws_internet_gateway.igw_tf]
}



resource "aws_route_table_association" "public-subnet-rt-association_tf" {
  subnet_id      = aws_subnet.public-subnet_tf.id
  route_table_id = aws_route_table.public-rt_tf.id
  depends_on     = [aws_subnet.public-subnet_tf, aws_route_table.public-rt_tf]
}

