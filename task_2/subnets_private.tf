resource "aws_subnet" "subnet_private_1" {
  vpc_id            = aws_vpc.vpc_task_2.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "private-1-subnet"
  }
}

resource "aws_subnet" "subnet_private_2" {
  vpc_id            = aws_vpc.vpc_task_2.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-north-1b"
  tags = {
    Name = "private-2-subnet"
  }
}
