resource "aws_security_group" "alb_sg" {
  name        = "flask-app-alb-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["168.161.22.1/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-alb-sg"
  }
}


resource "aws_lb" "flask_alb" {
  name               = "flask-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "flask_alb_tg" {
  name        = "flask-lb-tg"
  port        = 8001
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_lb_listener" "flask_alb_listener" {
  load_balancer_arn = aws_lb.flask_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_alb_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "flask_tg_attach" {
  target_group_arn = aws_lb_target_group.flask_alb_tg.arn
  target_id        = aws_instance.flask_ec2.private_ip
  port             = 8001
}
