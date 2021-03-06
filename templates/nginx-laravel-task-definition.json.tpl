[
    {
        "name": "${NGINX_CONTAINER_NAME}",
        "image": "${STACK_REPOSITORY_URL}:nginx-svc-${APP_VERSION}",
        "memory": 256,
        "cpu": 128,
        "essential": true,
        "portMappings": [
            {
            "hostPort": 80,
            "containerPort": 80,
            "protocol": "tcp"
            }
        ],
        "links": [
            "${BACKEND_APP}"
        ], 
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/awslogs-nginx-ecs",
                "awslogs-region": "us-east-1",
                "awslogs-stream-prefix": "ecs-nginx"
            }
        }
    },
    {
        "name": "${BACKEND_APP}",
        "image": "${STACK_REPOSITORY_URL}:${APP_VERSION}",
        "memory": 256,
        "cpu": 128,
        "essential": true,
        "workingDirectory": "${APP_WORK_DIR}",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/awslogs-laravel-ecs",
                "awslogs-region": "us-east-1",
                "awslogs-stream-prefix": "ecs-${BACKEND_APP}"
            }
        }
    }
]