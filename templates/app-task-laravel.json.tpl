[
    {
        "essential": true,
        "memory": 256,
        "name": "${CONTAINER_NAME}",
        "cpu": 256,
        "image": "${REPOSITORY_URL}:1",
        "workingDirectory": "${APP_WORK_DIR}",
        "command": ["php-fpm"],
        "portMappings": [
            {
                "containerPort": 9000,
                "hostPort": 9000
            }
        ]
    }
]