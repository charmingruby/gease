resource "aws_lb" "this" {
  name               = format("%s-lb", var.tags["project"])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnet_ids

  tags = merge(var.tags, {
    "Name" = format("%s-lb", var.tags["project"])
  })
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
