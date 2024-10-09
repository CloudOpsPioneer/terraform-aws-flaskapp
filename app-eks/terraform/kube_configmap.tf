locals {
  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.eks_node_group_iam_role.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:nodes", "system:bootstrappers"]
    },
    {
      rolearn  = "arn:aws:iam::730335614762:root"
      username = "my-aws-account-root"
      groups   = ["developer"]
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
