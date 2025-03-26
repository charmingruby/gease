resource "aws_lb_target_group" "this" {
  name        = format("%s-tg", var.tags["project"])
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  tags = merge(var.tags, {
    "Name" = format("%s-tg", var.tags["project"])
  })
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
