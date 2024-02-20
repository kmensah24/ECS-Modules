resource "aws_vpc" "ecommerce_vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = var.instance_tenancy
    enable_dns_hostnames = true
    enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"

  }
  
}

data "aws_availability_zones" "availability_zones" {
  
}

# Public subnet
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.ecommerce_vpc.id
  cidr_block              = var.public_subnet_az1_cidr 
  availability_zone       = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet-az1$" 
  }
}


# Public subnet
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.ecommerce_vpc.id
  cidr_block              = var.public_subnet_az2_cidr 
  availability_zone       = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-subnet-az2$" 
  }
}



# Private Subnet
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.ecommerce_vpc.id
  cidr_block              = var.private_subnet_az1_cidr 
  availability_zone       = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-privat-subnet-az1"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.ecommerce_vpc.id
  cidr_block              = var.private_subnet_az2_cidr 
  availability_zone       = data.aws_availability_zones.availability_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-privat-subnet-az2"
  }
}



#Internet gateway
resource "aws_internet_gateway" "pro-igw" {
  vpc_id = aws_vpc.ecommerce_vpc.id
  tags = {
    "Name"        = "${var.project_name}-igw"
    
  }
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ecommerce_vpc.id
  tags = {
    Name        = "${var.project_name}-private-route-table"
    
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecommerce_vpc.id

  tags = {
    Name        = "${var.project_name}-public-route-table"
    
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.pro-igw.id
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "pro_eip" {
tags = {
 Name ="pro-eip"
}

}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.pro_eip.id
  subnet_id     = aws_subnet.public_subnet_az1.id
  tags = {
    Name        = "${var.project_name}-nat-gateway"
    
  }
}

# nat gateway routing
resource "aws_route" "private-route" {
  route_table_id         = aws_route_table.private.id
  gateway_id             = aws_nat_gateway.nat.id
  destination_cidr_block = "0.0.0.0/0"

}