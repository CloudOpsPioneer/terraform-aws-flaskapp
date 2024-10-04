
variable "vpc_id" {
  type        = string
  default     = "vpc-05b4f2e13b7df5467"
  description = "VPC ID"
}

variable "private_subnet_id" {
  description = "private subnet id"
  default     = "subnet-03639446afdabc019"
}

variable "public_subnet_ids" {
  description = "public subnet id"
  default     = ["subnet-02983905d30bafdc4", "subnet-0276f7262ebf25799"]
}

variable "region" {
  type    = string
  default = "us-east-1"
}

