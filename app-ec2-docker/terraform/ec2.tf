#-------------------------------------------------<EC2>--------------------------------------------------
resource "aws_instance" "flask_ec2" {
  ami                    = data.aws_ami.linux.id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = "EC2-Role-admin"


  user_data = <<-EOF
    #!/bin/bash

    # Installing Docker
    sudo yum update -y
    sudo yum install docker -y
    sudo systemctl start docker
    sudo chmod 777 /var/run/docker.sock 

    # Downloading app files, building images and running as container
    mkdir ~/flask_app/
    aws s3 cp s3://my-code-bucket/flask_app/ ~/flask_app/ --recursive            #Update your bucket
    docker build ~/flask_app/ -t webapp
    docker run  -d -p 5000:8001 --name=webapp webapp            #App will be accessible  on port 5000 of the host
    curl http://localhost:5000
  EOF

  tags = {
    Name = "flask-ec2docker"
  }
}

