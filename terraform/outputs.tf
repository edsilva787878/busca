# Saídas para mostrar depois do deploy
output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.app_server.id
}

output "public_ip" {
  description = "IP público da EC2"
  value       = aws_eip.app_eip.public_ip
}

output "public_dns" {
  description = "DNS público da EC2"
  value       = aws_eip.app_eip.public_dns
}

output "security_group_id" {
  description = "ID do Security Group"
  value       = aws_security_group.app_sg.id
}

output "application_url" {
  description = "URL da aplicação"
  value       = "http://${aws_eip.app_eip.public_ip}:5000"
}

# Para usar em outras pipelines
output "ec2_ip" {
  description = "IP para usar no deploy"
  value       = aws_eip.app_eip.public_ip
  sensitive   = false
}