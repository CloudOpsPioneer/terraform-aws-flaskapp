#-------------------------------------------------<ECS SERVICE>--------------------------------------------------
resource "aws_ecs_service" "flask_app" {
  name            = "flask-svc"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.webapp.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  network_configuration {
    subnets         = [var.private_subnet_id]
    security_groups = [aws_security_group.ecs_svc_sg.id]
    #assign_public_ip = true 

    # Note : If you are using PUBLIC SUBNET, make sure to set [assign_public_ip = true]. Else you will see the below error when task tries to run

    #Set this to true if using public subnet. Else you will see -> ResourceInitializationError: unable to pull secrets or
    #registry auth: The task cannot pull registry auth from Amazon ECR: There is a connection issue between the task 
    #and Amazon ECR. Check your task network configuration. RequestError: send request failed caused by: 
    #Post "https://api.ecr.us-east-1.amazonaws.com/": dial tcp 44.213.79.50:443: i/o timeout

    # Doesn't matter if you are using PRIVATE SUBNET

  }

  load_balancer {
    target_group_arn = aws_lb_target_group.flask_alb_tg.arn
    container_name   = "flask-ui"
    container_port   = 8001
  }
  
  depends_on = [ aws_lb_listener.flask_alb_listener ]

}
