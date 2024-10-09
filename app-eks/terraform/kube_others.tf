resource "null_resource" "update_kubeconfig" {
  depends_on = [aws_eks_node_group.webapp_node_1]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.webapp_eks_cluster.name}"
  }

}

# terraform destroy will not delete ingress if finalizers available. 
# So, patching it to remove finalizers
resource "null_resource" "remove_ingress_finalizers" {
  triggers = {
    ingress_name = kubernetes_ingress_v1.flask_ingress.metadata[0].name
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "kubectl patch ingress ${self.triggers.ingress_name} -p '{\"metadata\":{\"finalizers\":[]}}' --type=merge"
    on_failure = continue
  }

  depends_on = [
    kubernetes_ingress_v1.flask_ingress
  ]
}
