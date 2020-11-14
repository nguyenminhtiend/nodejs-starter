resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = merge({
    Name = "nodejs-starter-vpc"
  }, var.tags)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "public" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = var.availability_zones[count.index]

  tags = merge({
    Name = "public-subnet-${count.index + 1}"
  }, var.tags)
}

resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${count.index + 3}.0/24"
  availability_zone = var.availability_zones[count.index]

  tags = merge({
    Name = "private-subnet-${count.index + 1}"
  }, var.tags)
}

resource "aws_eip" "nat_gw" {
  count = length(var.availability_zones)
  vpc   = true

  tags = merge({
    Name = "nat-gw-ip-${count.index + 1}"
  }, var.tags)

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.nat_gw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge({
    Name = "nat-gw-${count.index + 1}"
  }, var.tags)

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge({
    Name = "public-route"
  }, var.tags)
}

resource "aws_route_table" "private" {
  count = length(var.availability_zones)

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = merge({
    Name = "private-route-${var.availability_zones[count.index]}"
  }, var.tags)
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "web_private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_security_group" "load_balancer_security_group" {
  vpc_id      = aws_vpc.vpc.id
  name        = "ALB_SG"
  description = "ALB SG"

  ingress {
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

  tags = var.tags
}

resource "aws_security_group" "ecs_security_group" {
  vpc_id      = aws_vpc.vpc.id
  name        = "ECS_SG"
  description = "ECS SG"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}
