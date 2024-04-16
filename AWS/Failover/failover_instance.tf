resource "aws_instance" "disaster-recovery-bastion" {
  ami           = "ami-0b8b44ec9a8f90422"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.disaster-recovery-pub-subnet.id
  availability_zone = "us-east-2a"
  key_name = aws_key_pair.failover-key-pair.key_name
  vpc_security_group_ids = [aws_security_group.bastion-allow-ssh.id]
  user_data = "${file(var.USER_DATA)}"
  user_data_replace_on_change = "true"
  tags = {
    Name = "Disaster Recovery Bastion Host"
  }

}

resource "aws_instance" "disaster-recovery" {
  ami           = "ami-0b8b44ec9a8f90422"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.disaster-recovery-priv-subnet.id
  vpc_security_group_ids = [aws_security_group.disaster-recovery-private-ssh.id]
  key_name = aws_key_pair.failover-key-pair.key_name
  tags = {
    Name = "Disaster Recovery"
  }
}
resource "aws_key_pair" "failover-key-pair" {
  key_name   = "failover-key-pair"
  public_key = file(var.PUBLIC_KEY)
}
