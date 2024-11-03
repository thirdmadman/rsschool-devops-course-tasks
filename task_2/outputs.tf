output "test_variable" {
  value = "We are good to go!"
}

output "ec2_nat_gw_instance_public_ip" {
  description = "Public IP of the NAT instance"
  value       = aws_instance.ec2_instance_natgw.public_ip
}

output "ec2_private_1_instance_private_ip" {
  description = "Private IP of the private instance"
  value       = aws_instance.ec2_instance_subnet_private_1.private_ip
}

output "ec2_private_2_instance_private_ip" {
  description = "Private IP of the private instance"
  value       = aws_instance.ec2_instance_subnet_private_2.private_ip
}
