#create vpc

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# create internet gateway and attach it to vpc

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
    Environment = var.environment
  }
}



variable "availability_zones" {
  type = list(string)
  default = ["eu-south-1a", "eu-south-1b", "eu-south-1c"]
}

# create public subnet az1

resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
     Name        = "${var.project_name}-public-subnet-az1"
  Environment = var.environment
}
  }


# create public subnet az2

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

 tags = {
  Name        = "${var.project_name}-public-subnet-az2"
  Environment = var.environment
}
}


# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
  Name        = "${var.project_name}-public-rt"
  Environment = var.environment
}
}

# associate public subnet az1 to "public route table"

resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# create private app subnet az1
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_app_subnet_az1_cidr
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = false

 tags = {
  Name        = "${var.project_name}-private-app-subnet-az1"
  Environment = var.environment
}
}

# create private app subnet az2
resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_app_subnet_az2_cidr
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
  Name        = "${var.project_name}-private-app-subnet-az2"
  Environment = var.environment
}
}

# create private data subnet az1

resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_data_subnet_az1_cidr
  availability_zone = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
  Name        = "${var.project_name}-private-data-subnet-az1"
  Environment = var.environment
}
}

# create private data subnet az2
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_data_subnet_az2_cidr
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = false

 tags = {
  Name        = "${var.project_name}-private-data-subnet-az2"
  Environment = var.environment
}
}

