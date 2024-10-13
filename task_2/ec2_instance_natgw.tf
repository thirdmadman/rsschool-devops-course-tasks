resource "aws_instance" "ec2_instance_natgw" {
  ami           = "ami-097c5c21a18dc59ea"
  instance_type = "t3.nano"
  key_name      = "ec2-natgw-instance"

  subnet_id                   = aws_subnet.subnet_public_1.id
  security_groups             = [aws_security_group.sg_natgw.id]
  associate_public_ip_address = true

  tags = {
    Name = "ec2-instance-natgw"
  }

  user_data = file("script_ec2_instance_natgw_init.tpl")
}
