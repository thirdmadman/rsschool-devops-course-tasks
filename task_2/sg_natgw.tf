resource "aws_security_group" "sg_natgw" {
  vpc_id      = aws_vpc.vpc_task_2.id
  description = "Security group for EC2 NAT GW instance"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from internet"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.subnet_private_1.cidr_block]
    description = "Allow all inbound traffic from private subnet 2"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.subnet_private_2.cidr_block]
    description = "Allow all inbound traffic from private subnet 2"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "natgw-ec2-instance-sg"
  }
}
