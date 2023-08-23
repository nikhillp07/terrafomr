resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_instance" "test" {
  ami           =  var.ami_id
  instance_type = var.instance

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_instance" "prod" {
  ami           =  var.ami_id
  instance_type = var.instance

  tags = {
    Name = "HelloWorld"
  }
}
