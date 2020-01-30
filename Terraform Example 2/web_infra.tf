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

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.terra_VPC.id

  tags = {
    Name = "terra_IGW"
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

resource "aws_security_group" "pub_sg" {
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

resource "aws_instance" "pub" {
  ami           = "ami-05c64f7b4062b0a21"
  instance_type = "t2.micro"
  key_name = aws_key_pair.web_admin.key_name
  vpc_security_group_ids = [
    aws_security_group.pub_sg.id
  ]
  subnet_id = aws_subnet.terra_public_subnet1.id
  associate_public_ip_address = "true"

  tags = {
    Name = "GoodbyeWorld"
  }
}
