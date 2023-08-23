resource "aws_ebs_volume" "example" {
  availability_zone = "ap-southeast-2c"
  size              = 10

  tags = {
    Name = "main"
  }
}
