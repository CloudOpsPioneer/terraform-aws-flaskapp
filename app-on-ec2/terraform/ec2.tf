
resource "aws_instance" "flask_ec2" {
  ami                    = data.aws_ami.linux.id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = "EC2-Role-admin"


  user_data = <<-EOF
    #!/bin/bash
    wget https://bootstrap.pypa.io/get-pip.py
    python3 get-pip.py
    python3 -m pip install flask==3.0.3
    aws s3 cp s3://my-code-bucket-montreal/flask_app/webapp.py ~
    python3 ~/webapp.py
  EOF

  tags = {
    Name = "flask-app-ec2"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "flask-app-ec2-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-app-ec2-sg"
  }
}

resource "aws_security_group_rule" "ec2_ingress_rule_1" {
  type                     = "ingress"
  from_port                = 8001
  to_port                  = 8001
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.ec2_sg.id
}

