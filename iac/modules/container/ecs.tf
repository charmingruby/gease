resource "aws_ecs_cluster" "this" {
  name = format("%s-ecs-cluster", var.tags["project"])

  tags = merge(var.tags, {
    "Name" = format("%s-ecs-cluster", var.tags["project"])
  })
}

resource "aws_ecs_service" "this" {
  name                               = format("%s-ecs-service", var.tags["project"])
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = aws_ecs_task_definition.this.arn
  scheduling_strategy                = "REPLICA"
  desired_count                      = 2
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  depends_on                         = [aws_iam_role_policy.container_role, aws_alb_listener.this]

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "main"
    container_port   = 3000
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.lb_sg.id]
    assign_public_ip = true
  }

  tags = merge(var.tags, {
    "Name" = format("%s-ecs-service", var.tags["project"])
  })
}
