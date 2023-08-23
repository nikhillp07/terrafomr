variable "ami" {
 default="ami-06c13ede344452248"
}

#it's map data type
variable "instancename" {
 default= {
 web= "t2.micro"
 prod= "t3.micro"
 test= "t2.small"
}
}



variable "tagname" {
 default= {
 web= "web server"
 prod= "prod server"
 test= "test server"
}
}

resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instancename["web"]


  tags = {
    Name = var.tagname["web"]
  }
}

resource "aws_instance" "prod" {
  ami           = var.ami
  instance_type = var.instancename["prod"]

  tags = {
    Name = var.tagname["prod"]
  }
}

resource "aws_instance" "test" {
  ami           = var.ami
  instance_type = var.instancename["test"]

  tags = {
    Name = var.tagname["test"]
  }
}
