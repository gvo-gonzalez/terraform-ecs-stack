aws_region      = ""
aws_accessKey   = ""
aws_secretKey   = ""
ssl_certificate_arn = ""
instance_type   = "t2.micro"
asg_minSize     = 1
asg_maxSize     = 2

# Set ssh_keys that will load our instances
pub_sshkey_path             = "/path/to/ssh_key.pub"
jenkins_ec2_type            = "t2.micro"
ebs_device_name             = "/dev/xvdh"
# Variables required to configure task definition
ecs_cluster_name            = "ecsstack-ecs-cluster"
container_name              = "ecsstack-node-sample"
app_working_dir             = "/usr/local/app"
phpapp_container_name       = "ecsstack-laravel-sample"
phpapp_working_dir          = "/var/www"
ecr_stack_repo_name         = "ecsstack-ecr-repo"
app_services_enabled        = 1
js_stack_init_appversion    = 0
php_stack_init_appversion   = 0

# RDS variables
db_param_group_family   = "mariadb10.2"   
db_engine               = "mariadb"
db_engine_version       = "10.2.21"
db_instance_class       = "db.t2.micro"
db_identifier           = "ecs-laravel-backend"
db_instance_name        = "laravel_backend"
db_root_username        = "root"
db_rootpasswd           = "s3Cur3P4s5_wd0"
db_enable_multi_az      = "false"
db_storage_alloc        = 100
db_storage_type         = "gp2"
db_bkp_retention        = 30
final_snapshot_on_destroy  = true
nginx_conf_fastcgi_pass = "single-proj"

# Remote terraform backend states
tfstate_bucket = "s3tfstates.gvoweblab.com"
tfstate_key = "global/s3/terraform.tfstate"
tfstates_lockdb = "terraform-dblocking-states"
