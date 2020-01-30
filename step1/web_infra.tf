// 0.12.14 (November 13, 2019)
// Interpolation-only expressions are deprecated: an expression like "${foo}" should be rewritten as just foo.
resource "aws_key_pair" "web_admin" {
  key_name = "web_admin"
  public_key = file("~/.ssh/web_admin.pub")
}




// old version
resource "aws_key_pair" "web_admin" {
  key_name = "web_admin"
  public_key = "${file("~/.ssh/web_admin.pub")}"
}
