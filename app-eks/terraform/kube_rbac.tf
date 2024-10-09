#-------------------------------------------------<rbac for IAM roles to access kube api>--------------------------------------------------
resource "kubernetes_cluster_role_v1" "poc_np_admin" {
  metadata {
    name = "aws-msc-poc-nonprod-admin-clusterrole"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "pods/log"]
    verbs      = ["get", "list", "create", "delete", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }
  depends_on = [aws_eks_node_group.webapp_node_1]
}


resource "kubernetes_cluster_role_binding_v1" "poc_np_admin" {
  metadata {
    name = "aws-msc-poc-nonprod-admin-crb"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.poc_np_admin.metadata[0].name
  }
  subject {
    kind      = "Group"
    name      = "developer"
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [aws_eks_node_group.webapp_node_1]
}


