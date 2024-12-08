resource "aws_network_interface" "eni_ec2_natgw_private_1" {
  subnet_id   = aws_subnet.subnet_public_1.id
  description = "NAT private subnet 1 interface"
  tags = {
    Name = "private-1-ec2-natgw-eni"
  }
  security_groups   = [aws_security_group.sg_natgw.id]
  source_dest_check = false
}
