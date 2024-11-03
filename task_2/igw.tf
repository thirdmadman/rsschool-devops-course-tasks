resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_task_2.id
  tags = {
    Name = "main-igw"
  }
}
