resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.name}-vpc"
  }
}

# Only include Available AWS Availability Zones based on AWS_CLI Account Configuration
data "aws_availability_zones" "available" {
 state = "available"
 }

# Create 3 Public Subnets with CIDR Blocks as multiples of 10 plus an increment to avoid overlap
resource aws_subnet "public" {
  count = 3

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = "10.0.${count.index * 10 + 1}.0/24"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-public-subnet${count.index + 1}"
  }
}

# Create 3 Private Subnets with CIDR Blocks as multiples of 10 plus an increment of 10 to avoid overlap
resource "aws_subnet" "private" {
  count = 3

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = "10.0.${count.index * 10 + 10}.0/24"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-private-subnet${count.index + 1}"
  }
}