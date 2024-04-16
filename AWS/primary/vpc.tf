terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.41.0"
    }
  }
}

provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_vpc" "source-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "source-vpc"
  }
}
# Create the public subnet
resource "aws_subnet" "source-pub-subnet" {
  vpc_id = "${aws_vpc.source-vpc.id}"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "source-pub-subnet"
  }
}

# Create the private subnet
resource "aws_subnet" "source-priv-subnet" {
  vpc_id = "${aws_vpc.source-vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "source-priv-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "source-IGW" {
  vpc_id = "${aws_vpc.source-vpc.id}"
  tags = {
    Name = "source-IGW"
  }
}
# Elastic IP
#resource "aws_eip" "elasticIP" {
#  vpc = true
#}

# Route table
resource "aws_route_table" "source-pub-rt" {
  vpc_id = aws_vpc.source-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.source-IGW.id
  }
  tags = {
    Name = "source-pub-rt"
  }
}

# Route table
resource "aws_route_table_association" "source-pub-1-a" {
  route_table_id = aws_route_table.source-pub-rt.id
  subnet_id = aws_subnet.source-pub-subnet.id
}


