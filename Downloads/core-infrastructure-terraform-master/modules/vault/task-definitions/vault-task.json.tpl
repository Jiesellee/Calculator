[
    {
        "name": "vault",
        "image": "quay.io/stefancocora/vaultecs:v0.7.3.13",
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
            "server"
        ],
        "portMappings": [
            {
                "containerPort": 6443,
                "hostPort": 6443
            },
            {
                "containerPort": 6444,
                "hostPort": 6444
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${awslogs_group_path}",
                "awslogs-region": "eu-west-1",
                "awslogs-stream-prefix": "vault"
            }
        },
        "memory": ${ecs_vault_mem},
        "cpu": ${ecs_vault_cpu},
        "essential": true,
        "mountPoints": [],
        "environment": [
            {
                "name": "AWS_DEFAULT_REGION",
                "value": "${region}"
            },
            {
                "name": "VAULT_LOCAL_CONFIG_HCL",
                "value": "${vault_config_content}"
            },
            {
                "name": "VAULT_TLS_CERT",
                "value": "${vault_pem}"
            },
            {
                "name": "VAULT_TLS_KEY",
                "value": "${vault_key_pem}"
            },
            {
                "name": "VAULT_CLUSTER_AWS",
                "value": "true"
            },
            {
                "name": "VAULT_REDIRECT_AWS",
                "value": "true"
            },
            {
                "name": "VAULT_REDIRECT_ADDR",
                "value": "https://entrypoint_replaces:6443"
            },
            {
                "name": "VAULT_CLUSTER_ADDR",
                "value": "https://entrypoint_replaces:6444"
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
