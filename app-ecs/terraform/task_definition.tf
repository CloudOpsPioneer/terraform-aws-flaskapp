data "template_file" "task_definition" {
  template = file(format("%s/%s", path.module, "task_definition/task_definition.tpl"))

  vars = {
    container_name  = "flask-ui"
    container_image = awscc_ecr_repository.flask_ecr.repository_uri
    container_port  = 8001
    host_port       = 5000
    cpu             = 256
    memory          = 512
  }
}


resource "aws_ecs_task_definition" "task" {
  family                   = "flask-svc-td"
  execution_role_arn       = aws_iam_role.task_exec_iam_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.task_iam_role.arn
  container_definitions    = data.template_file.task_definition.rendered
}
