                                                # LOAD BALANCER
resource "aws_lb" "application_load_balancer" {
  name               = "${var.app_name}-${var.app_environment}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.security_group.id]

  tags = {
    Name        = "${var.app_name}-lb"
    Environment = var.app_environment
  }
}


                                                # HABILITA PORTA E PROTOCOLO QUE O LOAD BALANCER "OUVIRÁ"
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

                                                # DEFINE AS CONFIGURAÇÕES PARA A PORTA 5000 DO LOAD BALANCER
resource "aws_lb_target_group" "target_group" {
  name        = "${var.app_name}-${var.app_environment}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.aws-vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.app_name}-tg"
    Environment = var.app_environment
  }
}

                                                # HABILITA FIREWALL DO LOAD BALANCER
resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = aws_vpc.aws-vpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_name}-sg"
    Environment = var.app_environment
  }
}



