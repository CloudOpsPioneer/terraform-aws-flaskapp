#-------------------------------------------------<HELM CHARTS>--------------------------------------------------

#-------------------------------------------------<EKS ALB CONTROLLER>--------------------------------------------------
# https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html#lbc-helm-install
resource "helm_release" "aws-load-balancer-controller" {
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"
  version          = "1.9.0" # refer the README.md file to check available versions
  wait             = false
  create_namespace = false
  set {
    name  = "clusterName"
    value = aws_eks_cluster.webapp_eks_cluster.name
  }
  set {
    name  = "region"
    value = "us-east-1"
  }
  set {
    name  = "vpcId"
    value = var.vpc_id
  }
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  set {
    name  = "rbac.create"
    value = "true"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.eks_lb_iam_role.arn
  }
  # get image and tag from https://gallery.ecr.aws/eks/aws-load-balancer-controller
  set {
    name  = "image.repository"
    value = "public.ecr.aws/eks/aws-load-balancer-controller"
  }
  set {
    name  = "image.tag"
    value = "v2.9.0"
  }

  depends_on = [null_resource.update_kubeconfig]
}