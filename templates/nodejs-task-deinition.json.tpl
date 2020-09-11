[
    {
        "essential": true,
        "name": "${NODE_CONTAINER_NAME}",
        "image": "${NODE_REPOSITORY_URL}:${NODE_APP_VERSION}",
        "memory": 256,
        "cpu": 128,
        "portMappings": [
            {
                "hostPort": 8080,
                "containerPort": 3000,
                "protocol": "tcp"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/node-container-logs",
                "awslogs-region": "us-east-1",
                "awslogs-stream-prefix": "ecs-nodeapp"

            }
        }
    }
]