resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-subnet"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "gwmain"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
    tags = {
    Name = "public-rt"
  }
}

resource "aws_eip" "eipfornat" {
vpc = true
}

resource "aws_nat_gateway" "mynatgateway" {
allocation_id = aws_eip.eipfornat.id
subnet_id = aws_subnet.public-subnet.id
tags = {
Name = "Natgateway"
}
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.mynatgateway.id
  }
 tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_security_group" "sg" {
  name        = "allow_tls"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "my-sg"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "mykey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZr2g/tVWMgrKE18rfP+uVVstALKu7mKSYVnGgEk5ltGhwQyW1deSGwyLyi0OP6PHZ7BGQ1e6ZtctstAPIIK8nbM4hJr2Xg5RQO9dCRVEgyWxAKrt/1Nun9tGQO7fJKDAKbQmsaMGJI4bKtz717WUlS1TVuux+I+eG6ZxTU6yJRaXpaB07Blrz2RlfHw0FU/SeSGStok/NnC2D0C9Ovjd6Dg+jpCpUxxR7FWRGQgFRxmeCYRxgdtJUT0gSe2dJWQaRNAeBHH4mPGKbVfEOvbso/1nYuxejh4EcMJvlVpNTME+/5DjVPyrwgDNtxfuG1YeT8onEqnj+z4NA4ha1n6FIYKPutUWQReELqsla9WBzPYsZxIRT97vxENwF9haH6VgWLX+ZY3zmdWZks782TtEpJY7NgLv9AIT8ZGALqmASmOzhlCJa6W9kqNi3cGaxslKEEwBj4kZq1ZnpZ7Q0TbywWVvcGuV65NIkW2yUv9TdpRBVM01uAgP6BXGMnrNge0s= ec2-user@ip-172-31-27-201.ap-southeast-2.compute.internal"
}

resource "aws_instance" "public-server" {
ami = "ami-06c13ede344452248"
instance_type = "t2.micro"
subnet_id =aws_subnet.public-subnet.id
vpc_security_group_ids=[aws_security_group.sg.id]
key_name="mykey"
 tags = {
 Name = "public-server"

 user_data = <<-EOF
              #!/bin/bash
             sudu  yum install -y httpd
             sodu  systemctl enable httpd
             sudo  systemctl start httpd
             echo "<html><body><h1>Hello from your EC2 web server!</h1></body></html>" > /var/www/html/index.html
             EOF
}
}
resource "aws_eip" "lb" {
instance = aws_instance.public-server.id
vpc = true
}

resource "aws_instance" "private-server" {
ami = "ami-06c13ede344452248"
instance_type = "t2.micro"
subnet_id =aws_subnet.private-subnet.id
vpc_security_group_ids=[aws_security_group.sg.id]
key_name="mykey"
 tags = {
 Name = "private-server"
}
}
