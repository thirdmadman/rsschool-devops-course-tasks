resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc_task_2.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-north-1a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc_task_2.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-north-1b"
  tags = {
    Name = "private-subnet-2"
  }
}