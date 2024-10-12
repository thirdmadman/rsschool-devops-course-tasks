resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_task_2.id
  tags = {
    Name = "private-route-table"
  }
}

# Associate private subnets to the private route table
resource "aws_route_table_association" "private_rt_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}