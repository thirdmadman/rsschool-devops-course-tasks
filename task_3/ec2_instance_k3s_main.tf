resource "aws_instance" "k3s_main_ec2_instance" {
  ami             = "ami-097c5c21a18dc59ea"
  instance_type   = "t3.micro"
  key_name        = var.ec2_private_instance_key_name
  subnet_id       = aws_subnet.subnet_private_1.id
  security_groups = [aws_security_group.sg_private_ec2.id]

  tags = {
    Name = "k3s-main-ec2-instance"
  }

  user_data = file("script_ec2_instance_k3s_main_init.sh")
}
