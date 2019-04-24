[
    {
        "name": "vaultguard",
        "image": "quay.io/stefancocora/vaultguard:${vaultguard_version}",
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
            "vaultguard",
            "--debug",
            "--debugconfig",
            "--config",
            "/home/vaultguard/config.json"
        ],
        "portMappings": [
            {
                "containerPort": 8001,
                "hostPort": 8001
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${awslogs_group_path}",
                "awslogs-region": "eu-west-1",
                "awslogs-stream-prefix": "vaultguard"
            }
        },
        "memory": ${ecs_vaultguard_mem},
        "cpu": ${ecs_vaultguard_cpu},
        "essential": true,
        "mountPoints": [],
        "environment": [
            {
                "name": "AWS_DEFAULT_REGION",
                "value": "${region}"
            },
            {
                "name": "VAULTGUARD_LOCAL_CONFIG",
                "value": "${vaultguard_config_content}"
            }
        ],
        "ulimits" : [
            {
                "name" : "nofile",
                "softLimit" : 65536,
                "hardLimit" : 65536
            }
        ]
    }
]
