# Line 10 : Recommended for now to specify boolean values for variables as the strings "true" and "false" 

resource "aws_key_pair" "web_admin" {
  key_name = "web_admin"
  public_key = file("~/.ssh/web_admin.pub")
}

resource "aws_vpc" "terra_VPC" {
  cidr_block = "20.0.0.0/16"
  enable_dns_hostnames = "true" 
  enable_dns_support = "true"
  
  tags = {
    Name = "terra_VPC"
  }
}

resource "aws_subnet" "terra_public_subnet1" {
  vpc_id = aws_vpc.terra_VPC.id
  cidr_block = "20.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "terra_public_subnet1"
  }
}

resource "aws_subnet" "terra_private_subnet1" {
  vpc_id = aws_vpc.terra_VPC.id
  cidr_block = "20.0.2.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "terra_private_subnet1"
  }
}

resource "aws_subnet" "terra_public_subnet2" {
  vpc_id = aws_vpc.terra_VPC.id
  cidr_block = "20.0.11.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "terra_public_subnet2"
  }
}

resource "aws_subnet" "terra_private_subnet2" {
  vpc_id = aws_vpc.terra_VPC.id
  cidr_block = "20.0.12.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "terra_private_subnet2"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.terra_VPC.id

  tags = {
    Name = "terra_IGW"
  }
}

resource "aws_eip" "EIP" {
  vpc = true
}

resource "aws_nat_gateway" "NGW" {
  allocation_id = aws_eip.EIP.id
  subnet_id = aws_subnet.terra_public_subnet1.id

  tags = {
    Name = "NGW"
  }
}

resource "aws_route_table" "pub_route" {
  vpc_id = aws_vpc.terra_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "terra_pub_route"
  }
}

resource "aws_route_table_association" "pub_route_association1" {
  subnet_id = aws_subnet.terra_public_subnet1.id
  route_table_id = aws_route_table.pub_route.id
}

resource "aws_route_table_association" "pub_route_association2" {
  subnet_id = aws_subnet.terra_public_subnet2.id
  route_table_id = aws_route_table.pub_route.id
}

resource "aws_route_table" "pri_route" {
  vpc_id = aws_vpc.terra_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NGW.id
  }

  tags = {
    Name = "terra_pri_route"
  }
}

resource "aws_route_table_association" "pri_route_association1" {
  subnet_id = aws_subnet.terra_private_subnet1.id
  route_table_id = aws_route_table.pri_route.id
}

resource "aws_route_table_association" "pri_route_association2" {
  subnet_id = aws_subnet.terra_private_subnet2.id
  route_table_id = aws_route_table.pri_route.id
}

resource "aws_security_group" "pri_sg" {
  name = "SSH, HTTP, HTTPS"
  description = "Allow SSH, HTTP, HTTPS port from all"
  vpc_id = aws_vpc.terra_VPC.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  name = "HTTP, HTTPS"
  description = "Allow HTTP, HTTPS port from all"
  vpc_id = aws_vpc.terra_VPC.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "ALB" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.terra_public_subnet1.id, aws_subnet.terra_public_subnet2.id]
}

resource "aws_instance" "bastion" {
  ami           = "ami-05c64f7b4062b0a21"
  instance_type = "t2.micro"
  key_name = aws_key_pair.web_admin.key_name
  vpc_security_group_ids = [
    aws_security_group.pri_sg.id
  ]
  subnet_id = aws_subnet.terra_public_subnet1.id
  associate_public_ip_address = "true"

  tags = {
    Name = "GoodbyeWorld"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-05c64f7b4062b0a21"
  instance_type = "t2.micro"
  key_name = aws_key_pair.web_admin.key_name
  vpc_security_group_ids = [
    aws_security_group.pri_sg.id
  ]
  subnet_id = aws_subnet.terra_private_subnet1.id

  tags = {
    Name = "HelloWorld"
  }
}