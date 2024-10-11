#------------------------------------------------<KUBE DEPLOYMENT>------------------------------------------------#
resource "kubernetes_deployment_v1" "flask_deployment" {
  metadata {
    name = "flask-deployment"
    labels = {
      app = "flask"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "flask"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask"
        }
      }

      spec {
        container {
          image = awscc_ecr_repository.flask_ecr.repository_uri
          name  = "flask-ui"
          port {
            container_port = 8001
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          /*    liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          } */
        }
      }
    }
  }
  depends_on = [aws_eks_node_group.webapp_node_1]
}


/*
#YAML format of Deployment for better understanding
#---------------------------------------------------
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-deployment
  labels:
    app: flask
spec:
  replicas: 3
  selector:
    matchLabels:
      app: flask
  template:
    metadata:
      labels:
        app: flask
    spec:
      containers:
        - name: flask-ui
          image: <YOUR_ECR_REPOSITORY_URI>  
          ports:
            - containerPort: 8001
          resources:
            limits:
              cpu: "0.5"
              memory: "512Mi"
            requests:
              cpu: "250m"
              memory: "50Mi"
          # Uncomment the following if you wish to enable liveness probe
          # livenessProbe:
          #   httpGet:
          #     path: "/"
          #     port: 80
          #   initialDelaySeconds: 3
          #   periodSeconds: 3
*/
