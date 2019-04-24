[
  {
    "name": "concourse-init",
    "image": "002540887416.dkr.ecr.eu-west-1.amazonaws.com/concourse-init:${concourse_init_version}",
    "essential": false,
    "memory": 128,
    "cpu": 100,
    "placementStrategy": [
        {
            "field": "attribute:ecs.availability-zone",
            "type": "spread"
        },
        {
            "field": "instanceId",
            "type": "spread"
        }
    ],
    "environment": [
      { 
        "name": "CONCOURSE_COMPONENT", 
        "value": "web" 
      },
      {
        "name": "authorized_worker_keys",
        "value": "${authorized_worker_keys}"
      },
      {
        "name": "session_signing_key",
        "value": "${session_signing_key}"
      },
      {
        "name": "tsa_host_key",
        "value": "${tsa_host_key}"
      },
      ${additional_env_vars}
    ],    
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${aws_log_group}",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "web-init"
      }
    }
  },
  {
    "name": "concourse-web",
    "image": "concourse/concourse:${concourse_version}",
    "entryPoint": ["/home/concourse_entrypoint.sh"],
    "placementStrategy": [
        {
            "field": "attribute:ecs.availability-zone",
            "type": "spread"
        },
        {
            "field": "instanceId",
            "type": "spread"
        }
    ],
    "command": [
      "web"
    ],
    "cpu": ${ecs_web_cpu},
    "memory": ${ecs_web_memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      },
      {
        "containerPort": 2222,
        "hostPort": 2222
      }
    ],
    "volumesFrom": [
     {
       "sourceContainer": "concourse-init"
     }
    ],
    "environment": [
      {
        "name": "CONCOURSE_EXTERNAL_URL",
        "value": "${external_url}"
      },
      {
        "name": "CONCOURSE_BASIC_AUTH_USERNAME",
        "value": "concourse"
      },
      {
        "name": "CONCOURSE_BASIC_AUTH_PASSWORD",
        "value": "${basic_auth_password}"
      },
      {
        "name": "CONCOURSE_GITHUB_AUTH_CLIENT_ID",
        "value": "${github_auth_client_id}"
      },
      {
        "name": "CONCOURSE_GITHUB_AUTH_CLIENT_SECRET",
        "value": "${github_auth_client_secret}"
      },
      {
        "name": "CONCOURSE_GITHUB_AUTH_TEAM",
        "value": "${github_auth_team}"
      },
      {
        "name": "CONCOURSE_POSTGRES_DATA_SOURCE",
        "value": "postgres://concourse:${postgres_password}@${postgress_address}:5432/concourse?sslmode=disable"
      },
      ${additional_env_vars}
    ],
    "ulimits" : [
      {
        "name" : "nofile",
        "softLimit" : 65536,
        "hardLimit" : 65536
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${aws_log_group}",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "web"
      }
    }
  }
]
