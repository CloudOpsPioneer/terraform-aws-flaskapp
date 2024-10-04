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
    aws s3 cp s3://my-code-bucket/flask_app/webapp.py ~       #Update your bucket
    python3 ~/webapp.py
  EOF

  tags = {
    Name = "flask-ec2-local"
  }
}

