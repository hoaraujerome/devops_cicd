output "vpc_public_subnet_id" {
  value = aws_subnet.public.id
}

output "security_group_jenkins_server" {
  value = aws_security_group.jenkins_server.id
}