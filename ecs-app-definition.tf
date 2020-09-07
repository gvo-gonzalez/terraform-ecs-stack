# Creates APP ECR repository
resource "aws_ecr_repository" "ecsstack-ecr-repo" {
    name    = var.ecr_stack_repo_name
}

# Creates APP ECS cluster
resource "aws_ecs_cluster" "ecsstack-ecs-cluster" {
    name    = var.ecs_cluster_name
}

# Defines Template with our task definition for node service
data "template_file" "ecsstack-task-template" {
    template    = file("templates/app-task.json.tpl")
    vars = {
        # Vars for node service
        JS_CONTAINER_NAME   = var.container_name
        JS_REPOSITORY_URL   = replace(aws_ecr_repository.ecsstack-ecr-repo.repository_url, "https://", "")
        JS_APP_WORK_DIR     = var.app_working_dir
        JS_APP_VERSION      = var.js_stack_init_appversion
        
    }
}

# Defines Template with our task configuration for laravel service
data "template_file" "ecsstack-php-task-template" {
    template    = file("templates/php-fpm-nginx-task.json.tpl")
    vars = {
        # Vars for laravel services
        PHP_CONTAINER_NAME  = var.phpapp_container_name
        PHP_REPOSITORY_URL  = replace(aws_ecr_repository.ecsstack-ecr-repo.repository_url, "https://", "")
        PHP_APP_WORK_DIR    = var.phpapp_working_dir
        PHP_APP_VERSION     = var.php_stack_init_appversion
        PHP_FPM             = var.nginx_conf_fastcgi_pass
    }
}

resource "aws_ecs_task_definition" "ecsstack-task-definition" {
    family  = "nodejs-ecsstack"
    container_definitions   = data.template_file.ecsstack-task-template.rendered
}

resource "aws_ecs_task_definition" "ecsstack-php-task-definition" {
    container_definitions   = data.template_file.ecsstack-php-task-template.rendered
    network_mode            = "bridge"
    family                  = "nginx-php-fpm-stack"
    
}


# terraform apply -target aws_ecs_service.ecsstack-ecs-service -var app_services_enabled='1' -var MYAPP_VERSION=${MYAPP_VERSION}
# Creates ECS Service
resource "aws_ecs_service" "ecsstack-ecs-service" {
    # Run this statement not only the first time
    count = var.app_services_enabled
    name    = "ecsstack-ecs-service"
    cluster = aws_ecs_cluster.ecsstack-ecs-cluster.id
    task_definition = aws_ecs_task_definition.ecsstack-task-definition.arn
    desired_count   = 1
    iam_role    = aws_iam_role.ecsstack-service-role.arn
    depends_on  = [aws_iam_policy_attachment.ecsstack-service-attach]

    load_balancer   {
        target_group_arn    = aws_lb_target_group.ecsstack-lb-node-target.arn
        container_name  = var.container_name
        container_port  = 3000
    }

    lifecycle {
#        ignore_changes  = [task_definition]
        create_before_destroy = true
    }
}

resource "aws_ecs_service" "ecsstack-php-ecs-service" {
    # Run this statement not only the first time
    count = var.app_services_enabled
    name    = "ecsstack-php-ecs-service"
    cluster = aws_ecs_cluster.ecsstack-ecs-cluster.id
    task_definition = aws_ecs_task_definition.ecsstack-php-task-definition.arn
    desired_count   = 1
    iam_role    = aws_iam_role.ecsstack-service-role.arn
    depends_on  = [aws_iam_policy_attachment.ecsstack-service-attach]

    load_balancer   {
        target_group_arn    = aws_lb_target_group.ecsstack-lb-target.arn
        container_name  = var.phpapp_container_name
        container_port  = 80
    }

    lifecycle {
#        ignore_changes  = [task_definition]
        create_before_destroy = true
    }
}

