resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.vpc_task_2.id
  tags = {
    Name = "private_subnets_nacl"
  }

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

}

resource "aws_network_acl_association" "subnet_private_1" {
  subnet_id      = aws_subnet.subnet_private_1.id
  network_acl_id = aws_network_acl.public.id
}

resource "aws_network_acl_association" "subnet_private_2" {
  subnet_id      = aws_subnet.subnet_private_2.id
  network_acl_id = aws_network_acl.public.id
}
