[
  {
    "name": "data-volume",
    "image": "${ecr_image}:${ecr_image_tag}",
    "cpu": 10,
    "memory": 10,
    "essential": false,
    "entryPoint": [
      "echo"
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${service_name}-db-migration",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "data-volume"
      }
    }
  },
  {
    "name": "flyway",
    "image": "boxfuse/flyway:5.0.2-alpine",
    "cpu": 128,
    "memory": 256,
    "essential": true,
    "portMappings": [],
    "mountPoints": [],
    "environment": [],
    "workingDirectory": "/opt/service",
    "command": ${flyway_command},
    "volumesFrom": [
     {
       "sourceContainer": "data-volume"
     }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${log_group_name}",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "flyway"
      }
    }
  }
]
