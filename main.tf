# Define Listener on ALB. 
resource "aws_lb_listener" "service_lb" {
  load_balancer_arn = var.ecs_alb_arn
  port              = var.container_port

  default_action {
    target_group_arn = aws_lb_target_group.service_target.arn
    type             = "forward"
  }
}

# Define Target Group to route traffic to containers including Health Check within Container
resource "aws_lb_target_group" "service_target" {
  name        = var.service_name
  port        = var.container_port
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path    = "/healthcheck"
    matcher = "200"
  }
}

############ ecs-service ############
resource "aws_ecs_service" "this" {
  count           = var.create && !var.ignore_task_definition_changes ? 1 : 0
  name            = var.service_name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.desired_count

  enable_ecs_managed_tags           = var.enable_ecs_managed_tags
  enable_execute_command            = var.enable_execute_command
  force_new_deployment              = local.is_external_deployment ? null : var.force_new_deployment
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  launch_type                       = local.is_external_deployment ? null : var.launch_type

  dynamic "alarms" {
    for_each = length(var.alarms) > 0 ? [var.alarms] : []

    content {
      alarm_names = alarms.value.alarm_names
      enable      = try(alarms.value.enable, true)
      rollback    = try(alarms.value.rollback, true)
    }
  }

  dynamic "load_balancer" {
    for_each = { for k, v in local.load_balancer : k => v if !local.is_external_deployment }

    content {
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
      elb_name         = try(load_balancer.value.elb_name, null)
      target_group_arn = try(load_balancer.value.target_group_arn, null)
    }
  }

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  dynamic "network_configuration" {
    for_each = var.network_mode == "awsvpc" ? [{ for k, v in local.network_configuration : k => v if !local.is_external_deployment }] : []

    content {
      assign_public_ip = network_configuration.value.assign_public_ip
      security_groups  = network_configuration.value.security_groups
      subnets          = network_configuration.value.subnets
    }
  }

  lifecycle {
    ignore_changes = [
      desired_count, # Always ignored
    ]
  }

  triggers              = var.triggers
  wait_for_steady_state = var.wait_for_steady_state
  propagate_tags        = var.propagate_tags
  tags                  = var.tags
}
