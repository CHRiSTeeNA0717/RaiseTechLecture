# terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.31"
    }
  }
  required_version = ">= 1.2.0"
}

# provider
provider "aws" {
  region = var.region
}

# store tfstate in s3
terraform {
  backend "s3" {
    bucket = "my-tf-state-backend"
    key    = "tf-prod/tfstate"
    region = "ap-northeast-1"
  }
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.name}"
  }
}

# IGW
resource "aws_internet_gateway" "my_IGW" {
  tags = {
    Name = "${var.name}"
  }
}

# IGW attachment
resource "aws_internet_gateway_attachment" "my_IGW_attach" {
  vpc_id              = aws_vpc.my_vpc.id
  internet_gateway_id = aws_internet_gateway.my_IGW.id
}

# public subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-1"
  }
}

# private subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-private-1"
  }
}

# route table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.name}-route-table"
  }
}

# route table routing
resource "aws_route" "public_IGW" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_IGW.id
}

# route table assoc
resource "aws_route_table_association" "public_subnet" {
  route_table_id = aws_route_table.my_route_table.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

# route table private
resource "aws_route_table" "my_route_table_private" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.name}-private"
  }
}

# route table assoc private
resource "aws_route_table_association" "private_subnet" {
  route_table_id = aws_route_table.my_route_table_private.id
  subnet_id      = aws_subnet.private_subnet_1.id
}


# instance (referencing launch template)
resource "aws_instance" "my_web_instance" {
  launch_template {
    name = var.launch_template
    version = "$Latest"
  }

  subnet_id                   = aws_subnet.public_subnet_1.id
  security_groups             = [aws_security_group.public.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.name}-web"
  }
}

# SECURITY GROUP BELOW
# public security group
resource "aws_security_group" "public" {
  name        = "${var.name}-public"
  description = "Public internet access"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_security_group_rule" "public_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id
}

# Private security group

resource "aws_security_group" "private" {
  name        = "${var.name}-private"
  description = "Private internet access"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.name}-private"
  }
}

resource "aws_security_group_rule" "private_in" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = [aws_vpc.my_vpc.cidr_block]

  security_group_id = aws_security_group.private.id
}