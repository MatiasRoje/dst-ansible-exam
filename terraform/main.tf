terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# Create a key-pair for Ansible
resource "aws_key_pair" "ansible" {
  key_name   = "ansible"
  public_key = file("~/.ssh/ansible.pub")
}

# Security group for wordpress server
resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

# Security group for MySQL server
resource "aws_security_group" "mysql_sg" {
  name        = "mysql_sg"
  description = "Allow MySQL and SSH traffic"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

# EC2 instance for wordpress
resource "aws_instance" "wordpress" {
  ami           = "ami-0932dacac40965a65" # Ubuntu Server 22.04
  instance_type = "t2.small"
  key_name      = aws_key_pair.ansible.key_name

  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]

  tags = {
    Name = "Wordpress-Server"
  }
}

# EC2 instance for MySQL
resource "aws_instance" "mysql" {
  ami           = "ami-0932dacac40965a65" # Ubuntu Server 22.04
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ansible.key_name

  vpc_security_group_ids = [aws_security_group.mysql_sg.id]

  tags = {
    Name = "MySQL-Server"
  }
}

output "wordpress_instance_public_ip" {
  value = aws_instance.wordpress.public_ip
}

output "mysql_instance_public_ip" {
  value = aws_instance.mysql.public_ip
}
