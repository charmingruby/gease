resource "aws_ecs_task_definition" "this" {
  family                   = "gease"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.container_role.arn
  cpu                      = 1024
  memory                   = 2048
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    {
      name      = "main"
      image     = format("%s:latest", aws_ecr_repository.this.repository_url)
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

data "aws_ecs_task_definition" "this" {
  task_definition = aws_ecs_task_definition.this.family
}
