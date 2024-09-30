data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.5.20240916.0-kernel-6.1-x86_64"]
  }

}

resource "aws_instance" "web" {
  ami           = data.aws_ami.linux.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}
