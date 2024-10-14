variable "vpc_cidr" {
  description = "The VPC cidr"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_public_1" {
  description = "The public subnet 1 cidr"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_public_2" {
  description = "The public subnet 2 cidr"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet_private_1" {
  description = "The private subnet 1 cidr"
  type        = string
  default     = "10.0.3.0/24"
}

variable "subnet_private_2" {
  description = "The private subnet 2 cidr"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zone_1" {
  description = "The availability zone 1"
  type        = string
  default     = "eu-north-1a"
}

variable "availability_zone_2" {
  description = "The availability zone 2"
  type        = string
  default     = "eu-north-1b"
}


variable "ec2_natgw_instance_key_name" {
  description = "The private key name in AWS for the EC2 NAT GW instance"
  type        = string
  default     = "ec2-natgw-instance"
}

variable "ec2_private_instance_key_name" {
  description = "The private key name in AWS for the EC2 private (test) instance"
  type        = string
  default     = "ec2-private-instances"
}