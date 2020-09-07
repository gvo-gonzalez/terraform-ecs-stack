[
    {
        "essential": true,
        "memory": 256,
        "name": "${PHP_CONTAINER_NAME}",
        "cpu": 256,
        "image": "${PHP_REPOSITORY_URL}:${PHP_APP_VERSION}",
        "workingDirectory": "${PHP_APP_WORK_DIR}",
        "command": ["php-fpm"],
        "portMappings": [
            {
                "containerPort": 9000,
                "hostPort": 9000
            }
        ]
    }
]