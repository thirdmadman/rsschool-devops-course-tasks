resource "aws_subnet" "subnet_public_1" {
  vpc_id                  = aws_vpc.vpc_task_2.id
  cidr_block              = var.subnet_public_1
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true
  tags = {
    Name = "public-1-subnet"
  }
}

resource "aws_subnet" "subnet_public_2" {
  vpc_id                  = aws_vpc.vpc_task_2.id
  cidr_block              = var.subnet_public_2
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true
  tags = {
    Name = "public-2-subnet"
  }
}
