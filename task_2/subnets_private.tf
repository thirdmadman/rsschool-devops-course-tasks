resource "aws_subnet" "subnet_private_1" {
  vpc_id            = aws_vpc.vpc_task_2.id
  cidr_block        = var.subnet_private_1
  availability_zone = var.availability_zone_1
  tags = {
    Name = "private-1-subnet"
  }
}

resource "aws_subnet" "subnet_private_2" {
  vpc_id            = aws_vpc.vpc_task_2.id
  cidr_block        = var.subnet_private_2
  availability_zone = var.availability_zone_2
  tags = {
    Name = "private-2-subnet"
  }
}
