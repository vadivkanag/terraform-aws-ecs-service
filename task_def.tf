resource "aws_ecs_task_definition" "service" {
  family                   = var.service_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.task_exec[0].arn
  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = var.image
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = tonumber(var.container_port)
          hostPort      = tonumber(var.container_port)
        }
      ]
      environment = [
        for key, value in var.env_vars :
        {
          name  = key
          value = value
        }
      ]
      healthCheck = {
        command = ["CMD-SHELL", "curl -f http://0.0.0.0:${var.container_port}/healthcheck || exit 1"]
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = var.log_group_name
          awslogs-region        = var.region
          awslogs-stream-prefix = var.service_name
        }
      }
    }
  ])
  tags = var.tags
}

resource "aws_cloudwatch_log_stream" "service" {
  name           = var.service_name
  log_group_name = var.log_group_name
}
