resource "aws_instance" "k3s_main_ec2_instance" {
  ami             = "ami-02db68a01488594c5"
  instance_type   = "t3.small"
  key_name        = var.ec2_private_instance_key_name
  subnet_id       = aws_subnet.subnet_private_1.id
  private_ip      = var.k3s_main_ec2_instance_private_ip
  security_groups = [aws_security_group.sg_private_ec2.id]

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "k3s-main-ec2-instance"
  }

  user_data = file("script_ec2_instance_k3s_main_init.sh")
}
