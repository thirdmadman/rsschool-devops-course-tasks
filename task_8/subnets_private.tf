resource "aws_subnet" "subnet_private_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_private_1
  availability_zone = var.availability_zone_1
  tags = {
    Name = "private-1-subnet"
  }
}