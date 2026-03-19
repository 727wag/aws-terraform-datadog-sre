# 1. Security Group (Firewall para deixar conectar nossa máquina)
resource "aws_security_group" "app_sg" {
    name = "app-server-sg"
    description = "Permitir conexoes para nossa maquina"

    ingress {
        from_port = 22
        to_port = 22    
        protocol = "tcp"
        cidr_blocks = ["${var.meu_ip}/32"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# 2. Instância EC2
resource "aws_instance" "monitoring_lab" {
  ami = "ami-0c7217cdde317cfec" # imagem do Amazon Linux 2023 (us-east-1)
  instance_type = "t3.micro" # máquina Free Tier
  vpc_security_group_ids = [aws_security_group.app_sg.id]

    user_data = <<-EOF
              #!/bin/bash
              DD_API_KEY=${var.datadog_api_key} DD_SITE="us5.datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
              EOF

    tags = {
        Name = "SRE-Monitoring-AWS-DD"
    }
}