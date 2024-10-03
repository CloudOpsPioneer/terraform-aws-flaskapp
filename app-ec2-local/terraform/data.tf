data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = var.ami_names
  }

}


data "aws_iam_instance_profile" "ec2_ins_prof" {
  name = "EC2-Role-admin"
}
