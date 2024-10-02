
resource "aws_instance" "flask_ec2" {
  ami           = data.aws_ami.linux.id
  instance_type = "t2.micro"
  subnet_id     = var.private_subnet_id

  tags = {
    Name = "flask-app-ec2"
  }
}
