[
    {
        "name": "${NGINX_CONTAINER_NAME}",
        "image": "${STACK_REPOSITORY_URL}:nginx-svc-${APP_VERSION}",
        "memory": "${NGINX_MEMORY_SIZE}",
        "cpu": "${NGINX_CPU_SIZE}",
        "essential": true,
        "portMappings": [
            {
            "hostPort": "${NGINX_HOST_PORT}",
            "containerPort": "{NGINX_CONTAINER_PORT}",
            "protocol": "tcp"
            }
        ],
        "links": [
            "${APP}"
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
        "name": "${APP}",
        "image": "${STACK_REPOSITORY_URL}:${APP_VERSION}",
        "memory": "${APP_MEMORY_SIZE}",
        "cpu": "${APP_CPU_SIZE}",
        "essential": true,
        "workingDirectory": "${APP_WORK_DIR}",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/awslogs-laravel-ecs",
                "awslogs-region": "us-east-1",
                "awslogs-stream-prefix": "ecs-${APP}"
            }
        }
    }
]