locals {
  subnet_ids      = ({ for k, v in aws_subnet.this : v.tags.Name => v.id })
  subnet_ids_list = values(local.subnet_ids)
}
