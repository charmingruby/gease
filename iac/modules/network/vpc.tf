resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"


  tags = merge(var.tags, {
    Name = format("%s-vpc", var.tags["project"])
  })
}

resource "aws_subnet" "this" {
  for_each = {
    "pub-a" : {
      cidr_block              = "10.0.1.0/24"
      map_public_ip_on_launch = true
      availability_zone       = format("%sa", var.aws_region)
    },
    "pub-b" : {
      cidr_block              = "10.0.2.0/24"
      map_public_ip_on_launch = true
      availability_zone       = format("%sb", var.aws_region)
    }
  }


  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  availability_zone       = each.value.availability_zone


  tags = merge(var.tags, {
    Name = format("%s-subnet-%s", var.tags["project"], each.key)
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags,
    {
      Name = format("%s-ig", var.tags["project"])
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "this" {
  for_each = local.subnet_ids

  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}
