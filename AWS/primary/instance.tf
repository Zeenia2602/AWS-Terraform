# Create a EC2 instance with public Subnet
resource "aws_instance" "source-bastion" {
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.source-pub-subnet.id
  availability_zone = "us-east-1a"
  key_name = aws_key_pair.stream-key-pair.key_name
  vpc_security_group_ids = [aws_security_group.bastion-allow-ssh.id]
  user_data = "${file(var.USER_DATA)}"
  user_data_replace_on_change = "true"
  tags = {
    Name = "Source Bastion Host"
  }

}

# Create EC2 instance with private Subnet for Stream
resource "aws_instance" "stream" {
  ami           = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.source-priv-subnet.id
  vpc_security_group_ids = [aws_security_group.source-private-ssh.id]
  key_name = aws_key_pair.stream-key-pair.key_name
  tags = {
    Name = "Stream"
  }
}
resource "aws_key_pair" "stream-key-pair" {
  key_name   = "stream-key-pair"
  public_key = file(var.PUBLIC_KEY)
}



