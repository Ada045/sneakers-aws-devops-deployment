data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "sneakers-app-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.app_name}-vpc"
  }
}

resource "aws_internet_gateway" "sneakers-app-igw" {
  vpc_id = aws_vpc.sneakers-app-vpc.id

  tags = {
    Name = "${var.app_name}-igw"
  }
}

resource "aws_subnet" "sneakers-app-subnet-a" {
  vpc_id                  = aws_vpc.sneakers-app-vpc.id
  cidr_block              = var.subnet-a
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-public-subnet-a"
  }
}

resource "aws_subnet" "sneakers-app-subnet-b" {
  vpc_id                  = aws_vpc.sneakers-app-vpc.id
  cidr_block              = var.subnet-b
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-subnet-b"
  }
}


resource "aws_default_route_table" "sneakers-app-rtb" {
  default_route_table_id = aws_vpc.sneakers-app-vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sneakers-app-igw.id
  }

  tags = {
    Name = "${var.app_name}-main-rtb"
  }
}