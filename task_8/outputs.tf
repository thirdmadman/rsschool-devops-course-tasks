output "test_variable" {
  value = "We are good to go!"
}

output "ec2_nat_gw_instance_public_ip" {
  description = "Public IP of the NAT instance"
  value       = aws_instance.ec2_instance_natgw.public_ip
}

output "ec2_nat_gw_instance_private_ip" {
  description = "Private IP of the NAT instance"
  value       = aws_instance.ec2_instance_natgw.private_ip
}

output "ec2_k3s_main_instance_private_ip" {
  description = "Private IP of the k3s main instance"
  value       = aws_instance.k3s_main_ec2_instance.private_ip
}

output "ssh_command" {
  description = "Command to ssh instance in private network"
  value       = "ssh -A -J ec2-user@${aws_instance.ec2_instance_natgw.public_ip} ec2-user@${aws_instance.k3s_main_ec2_instance.private_ip}"
}