data "external" "folder_hash" {
  program = ["sh", "-c", "find ${path.module}/app-ecs/terraform/app -type f -exec sha256sum {} + | sha256sum | cut -d' ' -f1"]
}


resource "awscc_ecr_repository" "flask_ecr" {
  repository_name      = "flask-app"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration = {
    scan_on_push = true
  }
}

resource "null_resource" "folder_change_trigger" {
  triggers = {
    folder_hash_sha = data.external.folder_hash.result
  }

  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${aws_ecr_repository.flask_ecr.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.flask_ecr.repository_url}
      docker build -t ${aws_ecr_repository.flask_ecr.repository_url}:latest -f ${path.module}/Dockerfile ${path.module}
      docker push ${aws_ecr_repository.flask_ecr.repository_url}:latest
    EOT
  }
}