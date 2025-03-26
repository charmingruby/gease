output "subnets_ids" {
  value = local.subnet_ids_list
}

output "vpc_id" {
  value = aws_vpc.this.id
}
