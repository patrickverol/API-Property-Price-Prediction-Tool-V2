# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Public Subnet for Flask App
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Private Subnet for FastAPI and RDS (AZ a)
resource "aws_subnet" "private_subnet_a" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2a"
}

# Additional Private Subnet for RDS (AZ b)
resource "aws_subnet" "private_subnet_b" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-2b"
}

# DB Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]

  tags = {
    Name = "RDS Subnet Group"
  }
}

# Internet Gateway for public access
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Route table for public subnet
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

# Route table for private subnet
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main_vpc.id
  # No default route to the internet, private-only subnet
}

# Route table association for private subnet a
resource "aws_route_table_association" "private_subnet_a_assoc" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route.id
}

# Route table association for private subnet b
resource "aws_route_table_association" "private_subnet_b_assoc" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route.id
}

# VPC Endpoint for S3 communication from private subnet
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.main_vpc.id
  service_name      = "com.amazonaws.us-east-2.s3"  # Change region if necessary
  vpc_endpoint_type = "Gateway"
  

  route_table_ids = [
    aws_route_table.private_route.id  # Only private route table
  ]
}

# Security Group for public Flask EC2
resource "aws_security_group" "flask_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Data source to get your public IP
data "http" "my_ip" {
  url = "http://checkip.amazonaws.com/"
}

# Security Group for the Bastion Host
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Use your IP with CIDR notation
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for FastAPI EC2
resource "aws_security_group" "fastapi_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port = 5001
    to_port   = 5001
    protocol  = "tcp"
    security_groups = [aws_security_group.flask_sg.id]  # Allow from Flask EC2 only
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]  # Allow from Bastion Host only
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.fastapi_sg.id]  # Allow from FastAPI EC2 only
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

