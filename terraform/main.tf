# Can be changed to eu-north-e but then you have to change the ami and check what will the instance be ran on
provider "aws" {
  region = "us-east-1"
}
resource "aws_key_pair" "ansible_key_pair" {
  key_name   = "ansible_key_pair"
  public_key = tls_private_key.ansible_key.public_key_openssh
}

resource "aws_instance" "webservers" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t3.micro"
  vpc_security_group_ids = [
    aws_security_group.allow_web_traffic.id
  ]

  key_name = aws_key_pair.ansible_key_pair.key_name
  user_data = file("${path.module}/resources/user_data.sh")

  tags = {
    Name = "web"
    Role = "webserver"
    Public = "true"
  }
}

resource "aws_security_group" "allow_web_traffic" {
  name        = "allow_web_traffic"
  description = "Allow inbound web traffic"

  ingress {
    description = "TLS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from anywhere"
    from_port   = 444
    to_port     = 444
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web_traffic"
  }
}

output webservers {
  value = aws_instance.webservers.*.public_dns
}