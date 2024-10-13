resource "aws_instance" "ec2_instance_natgw" {
  ami           = "ami-097c5c21a18dc59ea"
  instance_type = "t3.nano"
  key_name      = "ec2-natgw-instance"

  network_interface {
    network_interface_id = aws_network_interface.eni_ec2_natgw_private_1.id
    device_index         = 0
  }

  tags = {
    Name = "ec2-instance-natgw"
  }

  user_data = file("script_ec2_instance_natgw_init.sh")
}
