resource "aws_instance" "web" {
  ami           = "ami-06c13ede344452248"
  instance_type = "t2.micro"

  tags = {
    Name = "web-server"
  }
}
