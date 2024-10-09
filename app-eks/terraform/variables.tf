variable "vpc_id" {
  type        = string
  default     = "vpc-05b4f2e13b7df5467"
  description = "VPC ID"
}

variable "region" { default = "us-east-1" }

variable "node_instance_types" { default = ["t3.medium"] }

variable "private_subnet_ids" { default = ["subnet-03639446afdabc019", "subnet-0f4ba4b32ec2d3452"] }

variable "public_subnet_ids" { default = ["subnet-02983905d30bafdc4", "subnet-0276f7262ebf25799"] }
