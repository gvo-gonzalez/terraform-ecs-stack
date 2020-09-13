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
    template    = file("templates/nodejs-task-deinition.json.tpl")
    vars = {
        # Vars for node service
        NODE_CONTAINER_NAME     = var.nodecontainer_name
        NODE_REPOSITORY_URL     = replace(aws_ecr_repository.ecsstack-ecr-repo.repository_url, "https://", "")
        NODE_APP_WORK_DIR       = var.nodeapp_working_dir
        NODE_APP_VERSION        = var.nodeapp_version_on_setup
#        NODE_MEMORY_SIZE        = var.nodeapp_container_memory_size
#        NODE_CPU_SIZE           = var.nodeapp_container_cpu_size
#        NODE_HOST_PORT          = var.nodeapp_host_port
#        NODE_CONTAINER_PORT     = var.nodeapp_container_port
    }
}

# Defines Template with our task configuration for laravel service
data "template_file" "ecsstack-php-task-template" {
    template    = file("templates/nginx-laravel-task-definition.json.tpl")
    vars = {
        # Vars for laravel services
        NGINX_CONTAINER_NAME    = var.phpapp_container_name
        STACK_REPOSITORY_URL    = replace(aws_ecr_repository.ecsstack-ecr-repo.repository_url, "https://", "")
        APP_WORK_DIR            = var.phpapp_working_dir
        APP_VERSION             = var.phpapp_version_on_setup
        BACKEND_APP             = var.nginx_fastcgi_app
#        NGINX_MEMORY_SIZE       = var.nginx_container_memory_size
#        NGINX_CPU_SIZE          = var.nginx_container_cpu_size
#        NGINX_HOST_PORT         = var.nginx_host_port
#        NGINX_CONTAINER_PORT    = var.nginx_container_port
#        APP_MEMORY_SIZE         = var.app_container_memory_size
#        APP_CPU_SIZE            = var.app_container_cpu_size
    }
}

resource "aws_ecs_task_definition" "ecsstack-task-definition" {
    family          = "nodejs-server"
    network_mode    = "bridge"
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
    #count = var.svc_running_tasks
    name    = "ecsstack-ecs-service-${substr(uuid(),0, 3)}"
    cluster = aws_ecs_cluster.ecsstack-ecs-cluster.id
    task_definition = aws_ecs_task_definition.ecsstack-task-definition.arn
    desired_count   = var.svc_running_tasks
    iam_role    = aws_iam_role.ecsstack-service-role.arn
    depends_on  = [aws_iam_policy_attachment.ecsstack-service-attach, aws_lb_listener.ecsstack-alb-node-listener]

    load_balancer   {
        target_group_arn    = aws_lb_target_group.ecsstack-lb-node-target.arn
        container_name      = var.nodecontainer_name
        container_port      = 3000
    }

    lifecycle {
#        ignore_changes  = [task_definition]
        create_before_destroy = true
    }
}

resource "aws_ecs_service" "ecsstack-php-ecs-service" {
    # Run this statement not only the first time
    #count = var.svc_running_tasks
    name    = "ecsstack-php-ecs-service-${substr(uuid(),0, 3)}"
    cluster = aws_ecs_cluster.ecsstack-ecs-cluster.id
    task_definition = aws_ecs_task_definition.ecsstack-php-task-definition.arn
    desired_count   = var.svc_running_tasks
    iam_role    = aws_iam_role.ecsstack-service-role.arn
    depends_on  = [aws_iam_policy_attachment.ecsstack-service-attach, aws_lb_listener.ecsstack-alb-php-http-listener]

    load_balancer   {
        target_group_arn    = aws_lb_target_group.ecsstack-lb-target.arn
        container_name      = var.phpapp_container_name
        container_port      = 80
    }

    lifecycle {
#        ignore_changes  = [task_definition]
        create_before_destroy = true
    }
}

