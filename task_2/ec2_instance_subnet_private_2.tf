resource "aws_instance" "ec2_instance_subnet_private_2" {
  ami             = "ami-097c5c21a18dc59ea"
  instance_type   = "t3.micro"
  key_name        = var.ec2_private_instance_key_name
  subnet_id       = aws_subnet.subnet_private_2.id
  security_groups = [aws_security_group.sg_private_ec2.id]

  tags = {
    Name = "private-ec2-instance-2"
  }

  user_data = file("script_ec2_instance_private_init.sh")
}
