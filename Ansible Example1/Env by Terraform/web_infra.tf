# Keypair
resource "aws_key_pair" "web_admin" {
  key_name = "web_admin"
  public_key = file("~/.ssh/web_admin.pub")
}

# Public subnet
data "aws_subnet" "PUB" {
  id = "subnet-058872fd6589f7f71"
}

# Security group
data "aws_security_group" "SG" {
  id = "sg-01dbc5eeb96774d4c"
}

# Creating 2 Instances for host
resource "aws_instance" "host1" {
  ami           = "ami-05c64f7b4062b0a21"
  instance_type = "t2.micro"
  key_name = aws_key_pair.web_admin.key_name
  vpc_security_group_ids = [
    data.aws_security_group.SG.id
  ]
  subnet_id = data.aws_subnet.PUB.id
  associate_public_ip_address = "true"

  tags = {
    Name = "host1"
  }
}

resource "aws_instance" "host2" {
  ami           = "ami-05c64f7b4062b0a21"
  instance_type = "t2.micro"
  key_name = aws_key_pair.web_admin.key_name
  vpc_security_group_ids = [
    data.aws_security_group.SG.id
  ]
  subnet_id = data.aws_subnet.PUB.id
  associate_public_ip_address = "true"

  tags = {
    Name = "host2"
  }
}