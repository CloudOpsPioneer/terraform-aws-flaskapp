#-------------------------EC2 Security Group-------------------------#
resource "aws_security_group" "ec2_sg" {
  name        = "flask-ec2docker-alb-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-ec2docker-alb-sg"
  }
}

resource "aws_security_group_rule" "ec2_ingress_rule_1" {
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.ec2_sg.id
}


#-------------------------ALB Security Group-------------------------#
resource "aws_security_group" "alb_sg" {
  name        = "flask-ec2docker-alb-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["168.x.x.x/32"] # Update your ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-ec2docker-alb-sg"
  }
}
