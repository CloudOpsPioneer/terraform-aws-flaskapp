resource "aws_ecs_service" "flask_app" {
  name            = "flask-svc"
  cluster         = aws_ecs_cluster.webapp.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  iam_role        = aws_iam_role.task_iam_role.arn


  load_balancer {
    target_group_arn = aws_lb_target_group.flask_alb_tg.arn
    container_name   = "flask-ui"
    container_port   = 8001
  }

}
