resource "aws_security_group" "bastion-allow-ssh" {
  vpc_id = "${aws_vpc.disaster-recovery-vpc.id}"
  name = "bastion-allow-ssh"
  description = "Security Group for bastion that allows ssh and all egress traffic"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bastion-allow-ssh"
  }
}

resource "aws_security_group" "disaster-recovery-private-ssh" {
  vpc_id = "${aws_vpc.disaster-recovery-vpc.id}"
  name = "source-private-ssh"
  description = "Security Group for private that allows ssh and all egress traffic"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion-allow-ssh.id]
  }
  tags = {
    Name = "disaster-recovery-private-ssh"
  }
}


