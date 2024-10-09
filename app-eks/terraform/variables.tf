variable "vpc_id" {
  type        = string
  default     = "vpc-05b4f2e13b7df5467"
  description = "VPC ID"
}

variable "region" { default = "us-east-1" }

variable "node_instance_types" { default = ["t3.medium"] }

variable "private_subnet_ids" { default = ["subnet-03639446afdabc019", "subnet-0f4ba4b32ec2d3452"] }

variable "public_subnet_ids" { default = ["subnet-02983905d30bafdc4", "subnet-0276f7262ebf25799"] }

variable "my_public_ip" {
  default     = "168.x.x.x/32"
  description = "my public ip where i will hit the ALB DNS name"
}

variable "my_private_ip" {
  default     = "172.31.x.x/32"
  description = "private ip of ec2 instance where i terraform and kubectl commands"

}
