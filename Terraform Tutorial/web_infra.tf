// 0.12.14 (November 13, 2019)
// Interpolation-only expressions are deprecated: an expression like "${foo}" should be rewritten as just foo.
resource "aws_key_pair" "web_admin" {
  key_name = "web_admin"
  public_key = file("~/.ssh/web_admin.pub")
}

resource "aws_security_group" "ssh" {
  name = "allow_ssh_from_all"
  description = "Allow SSH port from all"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_security_group" "default" {
  name = "default"
  vpc_id = "vpc-f2c9e695"
}

resource "aws_instance" "web" {
  ami = "ami-05c64f7b4062b0a21"
  instance_type = "t2.micro"
  key_name = aws_key_pair.web_admin.key_name
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
    data.aws_security_group.default.id
  ]
}

resource "aws_db_instance" "web_db" {
  allocated_storage = 8
  engine = "mysql"
  engine_version = "5.7.22"
  instance_class = "db.t2.micro"
  username = "admin"
  password = "password"
  skip_final_snapshot = true
}


// old version
resource "aws_key_pair" "web_admin" {
  key_name = "web_admin"
  public_key = "${file("~/.ssh/web_admin.pub")}"
}
