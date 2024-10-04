[
    {
      "name"         : "${container_name}",
      "image"        : "${container_image}",
      "cpu"          : ${cpu},
      "memory"       : ${memory},
      "essential"    : true,
      
      "portMappings" : [
        {
          "containerPort" : ${container_port},
          "hostPort"      : ${host_port},
          "protocol"      : "tcp"
        }
       ],

       "logConfiguration": {
           "logDriver": "awslogs",
           "options": {
             "awslogs-group": "${log_group}",
             "awslogs-region": "us-east-1",
             "awslogs-stream-prefix": "ecs",
             "awslogs-multiline-pattern": ".*((?:19|20)[0-9][0-9])-(0?[1-9]|1[012])-(0?[1-9]|[12][0-9]|3[01])"
           }
        }
      
    }
]
