resource "aws_security_group" "load_balancer_security_group" {
  name        = "application-load-balancer-security-group"
  description = "Inbound traffic Port 80 from anywhere"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MY-load-balancer-security-group"
  }
}
