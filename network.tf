resource "aws_vpc" "custom_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "ctf-vpc"
  }
}

locals {
  subnet_cidrs = [for i in range(var.subnet_count) : cidrsubnet(var.vpc_cidr, 4, i)]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.custom_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "custom_subnet" {
  count                   = var.subnet_count
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = local.subnet_cidrs[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))
  map_public_ip_on_launch = true
  tags = {
    Name = "ctf-subnet-${count.index + 1}"
  }

  depends_on = [aws_vpc.custom_vpc]
}