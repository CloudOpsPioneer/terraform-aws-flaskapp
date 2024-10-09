locals {
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::530694037299:role/webapp-eks-node-group-iam-role"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:nodes", "system:bootstrappers"]
    },
    {
      rolearn  = "arn:aws:iam::530694037299:role/aws-msc-poc-nonprod-admin"
      username = "aws-msc-poc-nonprod-admin"
      groups   = ["developer"]
    },
    {
      rolearn  = "arn:aws:iam::530694037299:role/EC2Admin"
      username = "ec2-admin"
      groups   = ["system:masters"]
    },
  ]
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = yamlencode(local.aws_auth_roles)
  }
  force = true

  depends_on = [aws_eks_node_group.webapp_node_1]
}
