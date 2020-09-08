variable    "aws_region" {}
variable    "aws_accessKey" {}
variable    "aws_secretKey" {}
variable    "ssl_certificate_arn" {}
variable    "instance_type" {}
variable    "asg_minSize" {}
variable    "asg_maxSize" {}
variable    "pub_sshkey_path" {}
variable    "jenkins_ec2_type" {}
variable    "ebs_device_name" {}
#variable    "jenkins_version" {}
variable    "ecs_cluster_name" {}
variable    "container_name" {}
variable    "app_working_dir" {}
#variable    "ecr_node_repo_name" {}
variable    "ecr_stack_repo_name" {}
variable    "phpapp_container_name" {}
variable    "phpapp_working_dir" {}
variable    "app_services_enabled" {}
variable    "js_stack_init_appversion" {}
variable    "php_stack_init_appversion" {}
variable    "nginx_conf_fastcgi_pass" {}
# RDS Section
variable db_param_group_family  {}
variable db_engine              {}
variable db_engine_version      {}
variable db_instance_class      {}
variable db_identifier          {}
variable db_instance_name       {}
variable db_root_username       {}
variable db_rootpasswd          {}
variable db_enable_multi_az     {}
variable db_storage_alloc       {}
variable db_storage_type        {}
variable db_bkp_retention       {}
variable final_snapshot_on_destroy {}
# Terraform states backend
variable tfstate_bucket {}
variable tfstate_key {}
variable tfstates_lockdb {}