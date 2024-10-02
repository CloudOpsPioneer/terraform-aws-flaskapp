variable "ami_names" {
  type        = list(string)
  default     = ["al2023-ami-2023.5.20240916.0-kernel-6.1-x86_64"]
  description = "AMI name of the AMI ID. Can be get by running -> aws ec2 describe-images --region us-east-1 --image-ids ami-0ebfd941bbafe70c6"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-05b4f2e13b7df5467"
  description = "VPC ID"
}

variable "private_subnet_id" {
  description = "private subnet id"
  default     = "subnet-03639446afdabc019"
}

variable "public_subnet_id" {
  description = "public subnet id"
  default     = "subnet-02983905d30bafdc4"
}


