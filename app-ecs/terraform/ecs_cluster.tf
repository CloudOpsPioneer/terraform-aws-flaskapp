resource "aws_ecs_cluster" "webapp" {
  name = "webapp-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
