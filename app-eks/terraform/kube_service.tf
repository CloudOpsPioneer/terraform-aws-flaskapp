#------------------------------------------------<KUBE SERVICE>------------------------------------------------#
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


/*
#YAML format of Service for better understanding
#---------------------------------------------------
apiVersion: v1
kind: Service
metadata:
  name: flask-svc
spec:
  selector:
    app: flask
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8001
  type: ClusterIP
*/
