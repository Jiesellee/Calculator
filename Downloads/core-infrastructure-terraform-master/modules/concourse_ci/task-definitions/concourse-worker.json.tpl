[
  {
    "name": "concourse-init",
    "image": "002540887416.dkr.ecr.eu-west-1.amazonaws.com/concourse-init:${concourse_init_version}",
    "essential": false,
    "memory": 128,
    "cpu": 100,
    "environment": [
      { 
        "name": "CONCOURSE_COMPONENT", 
        "value": "worker"
      },
      { 
        "name": "CONCOURSE_BAGGAGECLAIM_DRIVER",
        "value": "overlay"
      },
      {
        "name": "worker_key",
        "value": "${worker_key}"
      },
      {
        "name": "tsa_host_key_pub",
        "value": "${tsa_host_key_pub}"
      }
    ],    
    "mountPoints": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "${aws_log_group}",
          "awslogs-region": "eu-west-1",
          "awslogs-stream-prefix": "worker-init"
      }
    }
  },
  {
    "name": "concourse-worker",
    "image": "concourse/concourse:${concourse_version}",
    "command": [
      "worker"
    ],
    "cpu":  ${ecs_worker_cpu},
    "memory":  ${ecs_worker_memory},
    "essential": true,
    "privileged": true,
    "environment": [
      { 
        "name": "CONCOURSE_TSA_HOST", 
        "value": "${concourse_tsa_host}" 
      }
    ],    
    "mountPoints": [
      {
        "sourceVolume": "concourse-home",
        "containerPath": "/worker-state"
      },
      {
        "sourceVolume": "docker-dir",
        "containerPath": "/var/lib/docker"
      }
    ],
    "volumesFrom": [
     {
       "sourceContainer": "concourse-init"
     }
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
          "awslogs-stream-prefix": "worker"
      }
    }
  }
]
