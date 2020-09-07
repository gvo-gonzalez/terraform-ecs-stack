[
    {
        "essential": true,
        "memory": 256,
        "name": "${JS_CONTAINER_NAME}",
        "cpu": 256,
        "image": "${JS_REPOSITORY_URL}:${JS_APP_VERSION}",
        "workingDirectory": "${JS_APP_WORK_DIR}",
        "command": ["npm", "start"],
        "portMappings": [
            {
                "containerPort": 3000,
                "hostPort": 3000
            }
        ]
    }
]