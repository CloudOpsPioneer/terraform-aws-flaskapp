
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