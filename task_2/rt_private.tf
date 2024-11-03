resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_task_2.id
  tags = {
    Name = "private-route-table"
  }
}

# Add a route in the private route table for Internet-bound traffic through the NAT instance
resource "aws_route" "private_to_nat" {
  route_table_id         = aws_route_table.rt_private.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_network_interface.eni_ec2_natgw_private_1.id
}

# Associate private subnets to the private route table
resource "aws_route_table_association" "assoc_1_rt_private" {
  subnet_id      = aws_subnet.subnet_private_1.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "assoc_2_rt_private" {
  subnet_id      = aws_subnet.subnet_private_2.id
  route_table_id = aws_route_table.rt_private.id
}
