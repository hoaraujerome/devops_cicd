resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name      = "${var.project}-${var.environment}"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 1, 0)
  availability_zone       = var.az
  map_public_ip_on_launch = true

  tags = {
    Name      = "${var.project}-${var.environment}-public-subnet"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = "${var.project}-${var.environment}-igw"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = "${var.project}-${var.environment}-public-rt"
    ManagedBy = "${var.iac_tool}"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}