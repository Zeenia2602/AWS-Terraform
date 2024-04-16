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

resource "aws_vpc" "disaster-recovery-vpc" {
  cidr_block = "10.2.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "disaster-recovery-vpc"
  }
}
# Create the public subnet
resource "aws_subnet" "disaster-recovery-pub-subnet" {
  vpc_id = "${aws_vpc.disaster-recovery-vpc.id}"
  cidr_block = "10.2.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-2a"
  tags = {
    Name = "disaster-recovery-pub-subnet"
  }
}

# Create the private subnet
resource "aws_subnet" "disaster-recovery-priv-subnet" {
  vpc_id = "${aws_vpc.disaster-recovery-vpc.id}"
  cidr_block = "10.2.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "disaster-recovery-priv-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "disaster-recovery-IGW" {
  vpc_id = "${aws_vpc.disaster-recovery-vpc.id}"
  tags = {
    Name = "disaster-recovery-IGW"
  }
}
# Elastic IP
#resource "aws_eip" "elasticIP" {
#  vpc = true
#}

# Route table
resource "aws_route_table" "disaster-recovery-pub-rt" {
  vpc_id = aws_vpc.disaster-recovery-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.disaster-recovery-IGW.id
  }
  tags = {
    Name = "disaster-recovery-pub-rt"
  }
}

# Route table
resource "aws_route_table_association" "disaster-recovery-pub-1-a" {
  route_table_id = aws_route_table.disaster-recovery-pub-rt.id
  subnet_id = aws_subnet.disaster-recovery-pub-subnet.id
}
