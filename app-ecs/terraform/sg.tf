#-------------------------------------------------<ECS Service Security Group>--------------------------------------------------
resource "aws_security_group" "ecs_svc_sg" {
  name        = "flask-app-ecs-svc-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-app-ecs-svc-sg"
  }
}

resource "aws_security_group_rule" "ecs_svc_ingress_rule_1" {
  type                     = "ingress"
  from_port                = 8001
  to_port                  = 8001
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.ecs_svc_sg.id
}

#-------------------------------------------------<ALB Security Group>--------------------------------------------------
resource "aws_security_group" "alb_sg" {
  name        = "flask-app-ecs-alb-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["168.161.22.1/32"] # Update your ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-ecs-alb-sg"
  }
}
