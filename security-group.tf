resource "aws_security_group" "allow_ssh_tcp_tf" {
  name        = "allow_ssh_tcp_tf"
  description = "allow_ssh_tcp_tf"
  vpc_id      = aws_vpc.vpc_tf.id
  tags = {
    Name = "SG-For-hosting"
  }

  depends_on = [aws_vpc.vpc_tf]
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_ssh_tcp_tf.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  depends_on        = [aws_security_group.allow_ssh_tcp_tf]
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_ssh_tcp_tf.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  depends_on        = [aws_security_group.allow_ssh_tcp_tf]
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh_tcp_tf.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  depends_on        = [aws_security_group.allow_ssh_tcp_tf]
}



resource "aws_instance" "public_instance_1_tf" {
  ami                         = "ami-01811d4912b4ccb26"
  instance_type               = "t2.micro"
  key_name                    = "jenkins-key-2"
  vpc_security_group_ids      = [aws_security_group.allow_ssh_tcp_tf.id]
  subnet_id                   = aws_subnet.public-subnet_tf.id
  associate_public_ip_address = true
  tags = {
    Name = "PUBLIC_INSTANCE_1_TF"
  }
}


