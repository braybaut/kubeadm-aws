resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-${var.owner}"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw-${var.owner}"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

# Create a NAT Gateway
resource "aws_nat_gateway" "example" {

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["public_1"].id

  tags = {
    Name = "nat-${var.owner}"
  }

}

# Attach Internet Gateway to public subnets
resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "Public-Route-Table - ${var.owner}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }
  tags = {
    Name = "private-Route-Table - ${var.owner}"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = { for subnet in var.public_subnet : subnet.subnet_name => subnet }
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[each.value.subnet_name].id

}

resource "aws_route_table_association" "private" {
  for_each       = { for subnet in var.private_subnet : subnet.subnet_name => subnet }
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[each.value.subnet_name].id

}


resource "aws_subnet" "public" {
  for_each = { for subnet in var.public_subnet : subnet.subnet_name => subnet }

  cidr_block        = each.value.cidr
  availability_zone = each.value.availability_zone
  vpc_id            = aws_vpc.main.id

  tags = {
    Name = "Public-subnet-${var.owner}"
  }
}

resource "aws_subnet" "private" {
  for_each = { for subnet in var.private_subnet : subnet.subnet_name => subnet }

  cidr_block        = each.value.cidr
  availability_zone = each.value.availability_zone
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = "private-subnet-${var.owner}"
  }

}
