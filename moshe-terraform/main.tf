provider "aws" {
  region = "eu-west-1"
}

# Create subnets using a loop with count
resource "aws_subnet" "subnets" {
  count             = length(var.cidr_blocks)
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = var.subnet_names[count.index]
  }
}

# Create Route Table
resource "aws_route_table" "main" {
  vpc_id = var.vpc_id

  tags = {
    Name = "moshe-route-table"
  }

    # Route for internet-bound traffic through NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"  # Default route for all outbound traffic
    nat_gateway_id = "nat-0440e3c0e49d26497"  # Replace with your actual NAT Gateway ID
  }

}

# Associate subnets with the route table using a loop
resource "aws_route_table_association" "subnet_associations" {
  count         = length(var.cidr_blocks)
  subnet_id     = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.main.id
}


# Create an S3 bucket policy that references the external JSON file
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.name_bucket

  policy = file("bucket-policy.json")
}

