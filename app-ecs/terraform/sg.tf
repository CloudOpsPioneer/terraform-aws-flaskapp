#-------------------------ALB Security Group-------------------------#
resource "aws_security_group" "alb_sg" {
  name        = "flask-app-ecs-alb-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["168.161.22.1/32"]      # Update your ip
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
