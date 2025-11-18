data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  dns_suffix = data.aws_partition.current.dns_suffix
  partition  = data.aws_partition.current.partition
  region     = data.aws_region.current.region
}

# Service
locals {
  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/deployment-type-external.html
  is_external_deployment = try(var.deployment_controller.type, null) == "EXTERNAL"
  is_daemon              = var.scheduling_strategy == "DAEMON"
  is_fargate             = var.launch_type == "FARGATE"

  # Flattened `network_configuration`
  network_configuration = {
    assign_public_ip = var.assign_public_ip
    security_groups  = flatten(concat([try(aws_security_group.this[0].id, [])], var.security_group_ids))
    subnets          = var.subnet_ids
  }

  load_balancer = {
    internal-lb = {
      container_name   = var.service_name
      container_port   = var.container_port
      target_group_arn = aws_lb_target_group.service_target.arn
    },
  }
}
