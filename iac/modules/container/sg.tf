resource "aws_security_group" "lb_sg" {
  name        = format("%s-allow-http", var.tags["project"]) # Nome dinâmico baseado no projeto
  description = "Allow inbound HTTP traffic on port 80"      # Descrição mais clara
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    "Name" = format("%s-sg-lb", var.tags["project"])
  })
}
