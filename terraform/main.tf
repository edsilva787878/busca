# Security Group
resource "aws_security_group" "app_sg" {
  name        = "buscador-cep-sg"
  description = "Security Group para a aplicação"
  
  # SSH - Acesso restrito ao seu IP
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip]
  }
  
  # HTTP - Porta da aplicação (aberta para o mundo)
  ingress {
    description = "Application port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # HTTP - Porta 80 (opcional, se quiser expor depois)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # HTTPS - Porta 443 (opcional, se quiser expor depois)
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Saída - permite todo tráfego
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "buscador-cep-sg"
    Environment = "production"
    Project = "buscador-cep"
  }
}

# EC2 com Docker pré-instalado
resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  
  key_name = var.key_name
  
  # Script para instalar Docker automaticamente ao iniciar
  user_data = <<-EOF
    #!/bin/bash
    echo "=== Iniciando configuração da EC2 ==="
    
    # Atualizar sistema
    sudo yum update -y
    
    # Instalar Docker
    sudo yum install -y docker
    
    # Iniciar Docker
    sudo systemctl start docker
    sudo systemctl enable docker
    
    # Adicionar usuário ec2-user ao grupo docker
    sudo usermod -aG docker ec2-user
    
    # Instalar Git (opcional)
    sudo yum install -y git
    
    # Criar diretório para a aplicação
    mkdir -p /home/ec2-user/app
    
    echo "=== Docker instalado com sucesso! ==="
    echo "Aguardando deploy da aplicação..."
  EOF
  
  # Tags para identificar a instância
  tags = {
    Name = "buscador-cep"
    Environment = "production"
    Project = "buscador-cep"
    ManagedBy = "Terraform"
  }
  
  # Mantém o disco mesmo se a instância for terminada
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    delete_on_termination = true
    tags = {
      Name = "buscador-cep-root"
    }
  }
}

# Elastic IP (IP público fixo)
resource "aws_eip" "app_eip" {
  instance = aws_instance.app_server.id
  domain   = "vpc"
  
  tags = {
    Name = "buscador-cep-eip"
    Environment = "production"
  }
}