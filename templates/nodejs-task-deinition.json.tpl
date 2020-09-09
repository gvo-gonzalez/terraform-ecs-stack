[
    {
        "essential": true,
        "name": "${NODE_CONTAINER_NAME}",
        "image": "${NODE_REPOSITORY_URL}:${NODE_APP_VERSION}",
        "memory": "${NODE_MEMORY_SIZE}",
        "cpu": "${NODE_CPU_SIZE}",
        "portMappings": [
            {
                "hostPort": "${NODE_HOST_PORT}",
                "containerPort": "{NODE_CONTAINER_PORT}",
                "protocol": "tcp"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/node-container-logs",
                "awslogs-region": "us-east-1"
            }
        }
    }
]