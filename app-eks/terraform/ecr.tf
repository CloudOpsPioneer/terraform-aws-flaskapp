#-------------------------------------------------<ECR>--------------------------------------------------
resource "awscc_ecr_repository" "flask_ecr" {
  repository_name      = "flask-app-eks"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration = {
    scan_on_push = true
  }
}
