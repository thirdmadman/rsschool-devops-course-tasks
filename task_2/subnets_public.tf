resource "aws_subnet" "subnet_public_1" {
  vpc_id                  = aws_vpc.vpc_task_2.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-1-subnet"
  }
}

resource "aws_subnet" "subnet_public_2" {
  vpc_id                  = aws_vpc.vpc_task_2.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-2-subnet"
  }
}
