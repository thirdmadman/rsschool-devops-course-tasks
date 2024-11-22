resource "aws_vpc" "vpc_task_2" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-task-2"
  }
}