############ Common vars ############
variable "vpc_id" {
  description = "The VPC in which the cluster resides"
  type        = string
}

variable "ecs_cluster_id" {
  description = "The ARN of the ECS cluster"
  type        = string
}

variable "nginx_api_security_group_id" {
  description = "The ID of the security group of the NGINX API gateway service to add rules to"
  type        = string
}

variable "ecs_alb_security_group_id" {
  description = "The ID of the Application Load Balancer's security group to add rules to"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources into"
  type        = string
}

variable "create" {
  description = "Determines whether resources will be created (affects all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

############ Service ############
variable "ecs_alb_arn" {
  description = "The ID of the cluster's Application Load Balancer"
}

variable "ignore_task_definition_changes" {
  description = "Whether changes to service `task_definition` changes should be ignored"
  type        = bool
  default     = false
}

variable "alarms" {
  description = "Information about the CloudWatch alarms"
  type        = any
  default     = {}
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running. Defaults to `0`"
  type        = number
  default     = 1
}

variable "enable_ecs_managed_tags" {
  description = "Specifies whether to enable Amazon ECS managed tags for the tasks within the service"
  type        = bool
  default     = true
}

variable "enable_execute_command" {
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service"
  type        = bool
  default     = false
}

variable "force_new_deployment" {
  description = "Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination, roll Fargate tasks onto a newer platform version, or immediately deploy `ordered_placement_strategy` and `placement_constraints` updates"
  type        = bool
  default     = true
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers"
  type        = number
  default     = null
}

variable "launch_type" {
  description = "Launch type on which to run your service. The valid values are `EC2`, `FARGATE`, and `EXTERNAL`. Defaults to `FARGATE`"
  type        = string
  default     = "FARGATE"
}

variable "load_balancer" {
  description = "Configuration block for load balancers"
  type        = any
  default     = {}
}

variable "assign_public_ip" {
  description = "Assign a public IP address to the ENI (Fargate launch type only)"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security groups to associate with the task or service"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "List of subnets to associate with the task or service"
  type        = list(string)
  default     = []
}

variable "platform_version" {
  description = "Platform version on which to run your service. Only applicable for `launch_type` set to `FARGATE`. Defaults to `LATEST`"
  type        = string
  default     = null
}

variable "propagate_tags" {
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks. The valid values are `SERVICE` and `TASK_DEFINITION`"
  type        = string
  default     = null
}

variable "deployment_controller" {
  description = "Configuration block for deployment controller configuration"
  type        = any
  default     = {}
}

variable "scheduling_strategy" {
  description = "Scheduling strategy to use for the service. The valid values are `REPLICA` and `DAEMON`. Defaults to `REPLICA`"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Create, update, and delete timeout configurations for the service"
  type        = map(string)
  default     = {}
}

variable "triggers" {
  description = "Map of arbitrary keys and values that, when changed, will trigger an in-place update (redeployment). Useful with `timestamp()`"
  type        = any
  default     = {}
}

variable "wait_for_steady_state" {
  description = "If true, Terraform will wait for the service to reach a steady state before continuing. Default is `false`"
  type        = bool
  default     = null
}

############ Task Definition ############
variable "create_task_definition" {
  description = "Determines whether to create a task definition or use existing/provided"
  type        = bool
  default     = true
}

variable "task_definition_arn" {
  description = "Existing task definition ARN. Required when `create_task_definition` is `false`"
  type        = string
  default     = null
}

variable "container_definitions" {
  description = "A map of valid [container definitions](http://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html). Please note that you should only provide values that are part of the container definition document"
  type        = any
  default     = {}
}

variable "container_definition_defaults" {
  description = "A map of default values for [container definitions](http://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html) created by `container_definitions`"
  type        = any
  default     = {}
}

variable "cpu" {
  description = "Number of cpu units used by the task. If the `requires_compatibilities` is `FARGATE` this field is required"
  type        = number
  default     = 1024
}

variable "ephemeral_storage" {
  description = "The amount of ephemeral storage to allocate for the task. This parameter is used to expand the total amount of ephemeral storage available, beyond the default amount, for tasks hosted on AWS Fargate"
  type        = any
  default     = {}
}

variable "family" {
  description = "A unique name for your task definition"
  type        = string
  default     = null
}

variable "inference_accelerator" {
  description = "Configuration block(s) with Inference Accelerators settings"
  type        = any
  default     = {}
}

variable "ipc_mode" {
  description = "IPC resource namespace to be used for the containers in the task The valid values are `host`, `task`, and `none`"
  type        = string
  default     = null
}

variable "memory" {
  description = "Amount (in MiB) of memory used by the task. If the `requires_compatibilities` is `FARGATE` this field is required"
  type        = number
  default     = 2048
}

variable "network_mode" {
  description = "Docker networking mode to use for the containers in the task. Valid values are `none`, `bridge`, `awsvpc`, and `host`"
  type        = string
  default     = "awsvpc"
}

variable "pid_mode" {
  description = "Process namespace to use for the containers in the task. The valid values are `host` and `task`"
  type        = string
  default     = null
}

variable "proxy_configuration" {
  description = "Configuration block for the App Mesh proxy"
  type        = any
  default     = {}
}

variable "requires_compatibilities" {
  description = "Set of launch types required by the task. The valid values are `EC2` and `FARGATE`"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "runtime_platform" {
  description = "Configuration block for `runtime_platform` that containers in your task may use"
  type        = any
  default = {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

variable "skip_destroy" {
  description = "If true, the task is not deleted when the service is deleted"
  type        = bool
  default     = null
}

variable "volume" {
  description = "Configuration block for volumes that containers in your task may use"
  type        = any
  default     = {}
}

variable "task_tags" {
  description = "A map of additional tags to add to the task definition/set created"
  type        = map(string)
  default     = {}
}


############ Task Execution - IAM Role # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
variable "create_task_exec_iam_role" {
  description = "Determines whether the ECS task definition IAM role should be created"
  type        = bool
  default     = true
}

variable "task_exec_iam_role_arn" {
  description = "Existing IAM role ARN"
  type        = string
  default     = null
}

variable "task_exec_iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "task_exec_iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`task_exec_iam_role_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "task_exec_iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "task_exec_iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "task_exec_iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "task_exec_iam_role_tags" {
  description = "A map of additional tags to add to the IAM role created"
  type        = map(string)
  default     = {}
}

variable "task_exec_iam_role_policies" {
  description = "Map of IAM role policy ARNs to attach to the IAM role"
  type        = map(string)
  default     = {}
}

variable "create_task_exec_policy" {
  description = "Determines whether the ECS task definition IAM policy should be created. This includes permissions included in AmazonECSTaskExecutionRolePolicy as well as access to secrets and SSM parameters"
  type        = bool
  default     = true
}

variable "task_exec_ssm_param_arns" {
  description = "List of SSM parameter ARNs the task execution role will be permitted to get/read"
  type        = list(string)
  default     = ["arn:aws:ssm:*:*:parameter/*"]
}

variable "task_exec_secret_arns" {
  description = "List of SecretsManager secret ARNs the task execution role will be permitted to get/read"
  type        = list(string)
  default     = ["arn:aws:secretsmanager:*:*:secret:*"]
}

variable "task_exec_iam_statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  type        = any
  default     = {}
}

########### Tasks - IAM role # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html
variable "create_tasks_iam_role" {
  description = "Determines whether the ECS tasks IAM role should be created"
  type        = bool
  default     = true
}

variable "tasks_iam_role_arn" {
  description = "Existing IAM role ARN"
  type        = string
  default     = null
}

variable "tasks_iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "tasks_iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`tasks_iam_role_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "tasks_iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "tasks_iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "tasks_iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "tasks_iam_role_tags" {
  description = "A map of additional tags to add to the IAM role created"
  type        = map(string)
  default     = {}
}

variable "tasks_iam_role_policies" {
  description = "Map of IAM role policy ARNs to attach to the IAM role"
  type        = map(string)
  default     = {}
}

variable "tasks_iam_role_statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  type        = any
  default     = {}
}

########### Autoscaling ###########
variable "enable_autoscaling" {
  description = "Determines whether to enable autoscaling for the service"
  type        = bool
  default     = true
}

variable "autoscaling_min_capacity" {
  description = "Minimum number of tasks to run in your service"
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of tasks to run in your service"
  type        = number
  default     = 10
}

variable "autoscaling_policies" {
  description = "Map of autoscaling policies to create for the service"
  type        = any
  default = {
    cpu = {
      policy_type = "TargetTrackingScaling"

      target_tracking_scaling_policy_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ECSServiceAverageCPUUtilization"
        }
      }
    }
    memory = {
      policy_type = "TargetTrackingScaling"

      target_tracking_scaling_policy_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ECSServiceAverageMemoryUtilization"
        }
      }
    }
  }
}

variable "autoscaling_scheduled_actions" {
  description = "Map of autoscaling scheduled actions to create for the service"
  type        = any
  default     = {}
}


########### Security Group ###########
variable "create_security_group" {
  description = "Determines if a security group is created"
  type        = bool
  default     = true
}

variable "security_group_name" {
  description = "Name to use on security group created"
  type        = string
  default     = null
}

variable "security_group_use_name_prefix" {
  description = "Determines whether the security group name (`security_group_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "security_group_description" {
  description = "Description of the security group created"
  type        = string
  default     = null
}

variable "security_group_rules" {
  description = "Security group rules to add to the security group created"
  type        = any
  default     = {}
}

variable "security_group_tags" {
  description = "A map of additional tags to add to the security group created"
  type        = map(string)
  default     = {}
}

########### ecs task definition template vars ###########
variable "service_name" {
  description = "The name of the service that the containers provide"
}

variable "env_vars" {
  type    = map(string)
  default = {}
}

variable "image" {
  description = "The URL of the docker image to fetch"
}

variable "command" {
  description = "Override the command run by the container"
  default     = []
  type        = list(string)
}

variable "container_port" {
  description = "The port to attach to the container host on from the Application Load Balancer"
  type        = string
}

variable "entrypoint" {
  default     = []
  description = "Override for the default container entrypoint"
  type        = list(string)
}

variable "log_group_name" {
  description = "The Cloudwatch Log Group to log into"
}

variable "service_role_arn" {
  description = "The ID of the IAM role which the service should run under"
}
