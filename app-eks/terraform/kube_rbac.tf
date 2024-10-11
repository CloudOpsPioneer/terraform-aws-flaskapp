#-------------------------------------------------<rbac for IAM roles to access kube api>--------------------------------------------------
resource "kubernetes_cluster_role_v1" "aws_root_admin" {
  metadata {
    name = "aws-root-clusterrole"
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


resource "kubernetes_cluster_role_binding_v1" "aws_root_admin" {
  metadata {
    name = "aws-root-crb"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.aws_root_admin.metadata[0].name
  }
  subject {
    kind      = "Group"
    name      = "developer"
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [aws_eks_node_group.webapp_node_1]
}


/*
#YAML format of ClusterRole for better understanding
#---------------------------------------------------
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: aws-root-clusterrole
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/log"]
    verbs: ["get", "list", "create", "delete", "watch"]
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["get", "list", "watch"]


#YAML format of ClusterRoleBinding for better understanding
#----------------------------------------------------------
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: aws-root-crb
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: aws-root-clusterrole
subjects:
- kind: Group
  name: developer
  apiGroup: rbac.authorization.k8s.io

*/
