output "security_group_public" {
  value = aws_security_group.public.id
}

output "security_group_private" {
  value = aws_security_group.private.id
}

output "VPC_id" {
  value = aws_vpc.my_vpc.id
}

output "EC2_ip" {
  value = aws_instance.my_web_instance.public_ip
}