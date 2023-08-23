resource "aws_instance" "web" {
  ami           = "ami-06c13ede344452248"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

terraform {
  backend "s3" {
    bucket = "nikhil2203"
    key    = "nikhil"
    region = "ap-southeast-2"
    access_key = "AKIARKBBREQN4B6R6CGW"
    secret_key = "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" 
  }
}

