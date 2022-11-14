resource "aws_ecs_cluster" "this" {
  name               = var.id
  capacity_providers = ["FARGATE"]
  tags               = var.tags
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.id
  container_definitions    = jsonencode(local.container)
  execution_role_arn       = aws_iam_role.this.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  tags                     = var.tags
}

resource "aws_ecs_service" "this" {
  name                              = var.id
  cluster                           = aws_ecs_cluster.this.id
  task_definition                   = aws_ecs_task_definition.this.arn
  desired_count                     = var.desired_count
  launch_type                       = "FARGATE"
  propagate_tags                    = "SERVICE"
  health_check_grace_period_seconds = 30
  depends_on                        = [aws_lb_listener_rule.this]
  tags                              = var.tags

  load_balancer {
    target_group_arn = aws_lb_target_group.this.id
    container_name   = local.container[0].name
    container_port   = local.container[0].portMappings[0].containerPort
  }

  network_configuration {
    security_groups = [aws_security_group.ecs.id]
    subnets         = tolist(var.private_subnet_ids)
  }
}

data "aws_region" "this" {}

locals {
  container = [
    {
      name        = "metabase"
      image       = var.image
      essential   = true
      environment = concat(local.environment, var.environment)

      secrets = [
        {
          name      = "MB_DB_PASS"
          valueFrom = module.aurora.master_password
        },
      ]

      portMappings = [
        {
          containerPort = 3000
        },
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = data.aws_region.this.name
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ]

  environment = [
    {
      name  = "JAVA_TIMEZONE"
      value = var.java_timezone
    },
    {
      name  = "MB_DB_TYPE"
      value = "mysql"
    },
    {
      name  = "MB_DB_DBNAME"
      value = module.aurora.database_name
    },
    {
      name  = "MB_DB_PORT"
      value = tostring(module.aurora.port)
    },
    {
      name  = "MB_DB_USER"
      value = module.aurora.master_username
    },
    {
      name  = "MB_DB_HOST"
      value = module.aurora.endpoint
    },
  ]
}

resource "aws_lb_target_group" "this" {
  name        = var.id
  port        = local.container[0].portMappings[0].containerPort
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  tags        = var.tags

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = [var.domain]
    }
  }
}

resource "aws_route53_record" "this" {
  name    = var.domain
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = false
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = var.id
  retention_in_days = var.log_retention
  tags              = var.tags
}
