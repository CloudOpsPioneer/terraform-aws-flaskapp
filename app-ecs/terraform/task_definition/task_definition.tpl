[    
    {
      name      = "${container_name}"
      image     = "${container_image}"
      cpu       = ${cpu}
      memory    = ${memory}
      essential = true
      portMappings = [
        {
          containerPort = ${container_port}
          hostPort      = ${host_port}
          "protocol": "tcp"
        }
      ]
    }
]
