resource "aws_instance" "web" {
  ami           = "ami-06c13ede344452248"
  instance_type = "t2.micro"

  tags = {
    Name = "main-server"

  }

  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
	      Systemctl enable httpd
              Systemctl start httpd
              echo "<html><body><h1>Hello from your EC2 web server!</h1></body></html>" > /var/www/html/index.html
              EOF

}

output "public_ip" {
  value = aws_instance.web.public_ip
}
