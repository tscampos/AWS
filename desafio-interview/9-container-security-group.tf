# Criação do grupo de segurança
resource "aws_security_group" "container_security-group" {
  name        = "container-security-group"
  vpc_id = aws_vpc.my_vpc.id

  # Regra de entrada permitindo tráfego do grupo de segurança do balanceador de carga
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  # Regra de saída permitindo todo o tráfego
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}