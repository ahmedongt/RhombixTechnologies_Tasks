terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Network Resources
resource "aws_vpc" "rhombix_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "Rhombix-VPC" }
}

resource "aws_subnet" "rhombix_public_subnet" {
  vpc_id                  = aws_vpc.rhombix_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = { Name = "Rhombix-Public-Subnet" }
}

resource "aws_internet_gateway" "rhombix_igw" {
  vpc_id = aws_vpc.rhombix_vpc.id
  tags = { Name = "Rhombix-IGW" }
}

resource "aws_route_table" "rhombix_public_rt" {
  vpc_id = aws_vpc.rhombix_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rhombix_igw.id
  }
}

resource "aws_route_table_association" "rhombix_rt_assoc" {
  subnet_id      = aws_subnet.rhombix_public_subnet.id
  route_table_id = aws_route_table.rhombix_public_rt.id
}

# 2. Security Group
resource "aws_security_group" "rhombix_web_sg" {
  name        = "rhombix-web-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.rhombix_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

# 3. Virtual Machine (EC2 Instance)
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "rhombix_web_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.rhombix_public_subnet.id
  vpc_security_group_ids = [aws_security_group.rhombix_web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Rhombix Technologies DevOps Internship - Task 3 Complete</h1>" > /var/www/html/index.html
              EOF

  tags = { Name = "Rhombix-Web-Server" }
}

# 4. Storage (S3 Bucket)
resource "aws_s3_bucket" "rhombix_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}