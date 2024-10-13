resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_task_2.id
  tags = {
    Name = "public-route-table"
  }
}

# Route to the Internet through the Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# TODO: fix name
# Associate public subnets to the public route table
resource "aws_route_table_association" "assoc_1_rt_public" {
  subnet_id      = aws_subnet.subnet_public_1.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "assoc_2_rt_public" {
  subnet_id      = aws_subnet.subnet_public_2.id
  route_table_id = aws_route_table.rt_public.id
}
