resource "aws_instance" "ec2_instance_natgw" {
  ami           = "ami-02db68a01488594c5"
  instance_type = "t3.micro"
  key_name      = var.ec2_natgw_instance_key_name

  network_interface {
    network_interface_id = aws_network_interface.eni_ec2_natgw_private_1.id
    device_index         = 0
  }

  tags = {
    Name = "ec2-instance-natgw"
  }

  user_data = file("script_ec2_instance_natgw_init.sh")
}
