
resource "aws_instance" "flask_ec2" {
  ami             = data.aws_ami.linux.id
  instance_type   = "t2.micro"
  subnet_id       = var.private_subnet_id
  security_groups = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "flask-app-ec2"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "flask-app-ec2-sg"
  }
}

resource "aws_security_group_rule" "ec2_ingress_rule_1" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.ec2_sg.id
}