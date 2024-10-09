#-------------------------------------------------<EKS NODE GROUP>--------------------------------------------------
resource "aws_eks_node_group" "webapp_node_1" {
  cluster_name    = aws_eks_cluster.webapp_eks_cluster.name
  node_group_name = "node-group-1"
  node_role_arn   = aws_iam_role.eks_node_group_iam_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  #instance_types = var.node_instance_types   # Mentioned in aws_launch_template

  # Launch template is not mandatory. I just want to try using it.
  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

}

