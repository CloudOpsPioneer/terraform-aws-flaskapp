#------------------------------------------------<KUBE INGRESS>------------------------------------------------#
resource "kubernetes_ingress_v1" "flask_ingress" {
  metadata {
    name = "flask-ingress"
    annotations = {
      "kubernetes.io/ingress.class"                  = "alb"
      "alb.ingress.kubernetes.io/load-balancer-name" = "flask-eks-alb"
      "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"        = "ip"
      "alb.ingress.kubernetes.io/subnets"            = join(",", var.public_subnet_ids)
      "alb.ingress.kubernetes.io/security-groups"    = aws_security_group.eks_flask_alb_sg.id
    }
  }

  spec {
    rule {
      http {
        path {
          backend {
            service {
              name = "flask-svc"
              port {
                number = 8080
              }
            }
          }
          path = "/"
        }
      }
    }
  }
  depends_on = [aws_eks_node_group.webapp_node_1, helm_release.aws-load-balancer-controller]
}

/*
#YAML format of Ingress for better understanding
#---------------------------------------------------
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: flask-ingress
  annotations:
    kubernetes.io/ingress.class: "alb"
    alb.ingress.kubernetes.io/load-balancer-name: "flask-eks-alb"
    alb.ingress.kubernetes.io/scheme: "internet-facing"
    alb.ingress.kubernetes.io/target-type: "ip"
    alb.ingress.kubernetes.io/subnets: "subnet-id1,subnet-id2,subnet-id3"
    alb.ingress.kubernetes.io/security-groups: "sg-abcdefgh"
spec:
  rules:
    - http:
        paths:
          - path: "/"
            pathType: ImplementationSpecific
            backend:
              service:
                name: flask-svc
                port:
                  number: 8080
*/
