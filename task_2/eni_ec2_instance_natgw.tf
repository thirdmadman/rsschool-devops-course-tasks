resource "aws_network_interface" "eni_ec2_natgw_private_1" {
  subnet_id   = aws_subnet.subnet_private_1.id
  description = "NAT private subnet 1 interface"
  tags = {
    Name = "private-1-ec2-natgw-eni"
  }
  security_groups   = [aws_security_group.sg_private_ec2.id]
  source_dest_check = false
}

resource "aws_network_interface_attachment" "eni_attachment_ec2_nat_private_1" {
  network_interface_id = aws_network_interface.eni_ec2_natgw_private_1.id
  instance_id          = aws_instance.ec2_instance_natgw.id
  device_index         = 1
}
