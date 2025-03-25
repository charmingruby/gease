resource "aws_ecs_cluster" "this" {
  name = format("%s-ecs-cluster", var.tags["project"])

  tags = merge(var.tags, {
    "Name" = format("%s-ecs-cluster", var.tags["project"])
  })
}
