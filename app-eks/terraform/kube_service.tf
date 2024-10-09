resource "kubernetes_service_v1" "flask_svc" {
  metadata {
    name = "flask-svc"
  }
  spec {
    selector = kubernetes_deployment_v1.flask_deployment.spec[0].template[0].metadata[0].labels

    port {
      port        = 8080
      target_port = 8001
    }

    type = "ClusterIP"
  }
  depends_on = [aws_eks_node_group.webapp_node_1]
}
