variable "instance_id" {
 type=list
 default = ["t2.micro","t3.small","t3.micro"]

}

variable "ami_id" {
 type=list
 default= ["ami-00ffa321011c2611f","ami-0310483fb2b488153"]
}

variable "tagname" {
 type=list
 default= ["main-server","second-server","another-server"]
}

variable input {
 type=number
}

resource "aws_instance" "web" {
  ami           = var.ami_id[0]
  instance_type = var.instance_id[count.index]
  count = var.input > 2 ? 3:0

  tags = {
    Name = var.tagname[count.index]
  }
}


