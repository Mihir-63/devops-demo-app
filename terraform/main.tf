data "aws_ami" "amazon_linux" { 
  most_recent = true 
  owners = ["amazon"] 
  filter { 
    name = "name" 
    values = ["al2023-ami-2023.*-x86_64"] 
    } 
  filter { 
    name = "virtualization-type" 
    values = ["hvm"] 
    } 
  }

resource "aws_security_group" "app_sg" {
  name        = "devops-demo-app-sg"
  description = "Allow SSH and app traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flask app"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name = "devops-deploy-key"

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    docker run -d -p 5000:5000 --restart unless-stopped ${var.dockerhub_username}/devops-demo-app:latest
  EOF

  tags = {
    Name = "devops-demo-app-server"
  }
}