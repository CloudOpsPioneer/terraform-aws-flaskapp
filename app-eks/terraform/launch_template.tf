#------------------------------------------------<LAUNCH TEMPLATE>------------------------------------------------#
resource "aws_launch_template" "eks_nodes" {
  name_prefix = "webapp-eks-nodes-"
  #image_id      = data.aws_ami.eks_node.id
  instance_type = var.node_instance_types[0]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp3"
      volume_size           = 20 # Size in GiB
      delete_on_termination = true
    }
  }

  # Launch template should not specify an instance profile. The noderole in your request will be used to construct an instance profile.
  #  iam_instance_profile {
  #    arn = aws_iam_instance_profile.eks_node_group_ins_profile.arn
  #  }

  # You must not specify a subnet in your launch template. All subnets must be specified in the aws_eks_node_group
  network_interfaces {
    #   associate_public_ip_address = false
    #   subnet_id                   = var.private_subnet_ids[0]                                                   
    security_groups = [aws_security_group.eks_node_group_sg.id]
  }
}
