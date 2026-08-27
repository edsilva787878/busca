variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Nome da chave SSH"
  type        = string
  default     = "key-server-app"
}

variable "allowed_ssh_ip" {
  description = "IP que pode acessar SSH"
  type        = string
  default     = "177.94.44.227/32"  # SEU IP
}

variable "ami_id" {
  description = "AMI da Amazon Linux 2023"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 us-east-1
}