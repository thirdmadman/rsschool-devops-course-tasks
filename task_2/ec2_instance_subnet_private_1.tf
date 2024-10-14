resource "aws_instance" "ec2_instance_subnet_private_1" {
  ami             = "ami-097c5c21a18dc59ea"
  instance_type   = "t3.micro"
  key_name        = var.ec2_private_instance_key_name
  subnet_id       = aws_subnet.subnet_private_1.id
  security_groups = [aws_security_group.sg_private_ec2.id]

  tags = {
    Name = "ec2-instance-subnet-private-1"
  }

  user_data = file("script_ec2_instance_private_init.sh")
}
