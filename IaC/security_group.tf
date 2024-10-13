resource "aws_security_group" "ml_api_sg" {
  name        = var.sg_name
  description = var.sg_description

  # HTTP traffic for Flask App
  ingress {
    description = var.http_description
    from_port   = var.http_from_port
    to_port     = var.http_to_port
    protocol    = var.http_protocol
    cidr_blocks = var.http_cidr_blocks
  }

  # Fastapi App
  ingress {
    description = var.fastapi_description
    from_port   = var.fastapi_from_port
    to_port     = var.fastapi_to_port
    protocol    = var.fastapi_protocol
    cidr_blocks = var.fastapi_cidr_blocks
  }
  
  # Flask App
  ingress {
    description = var.flask_description
    from_port   = var.flask_from_port
    to_port     = var.flask_to_port
    protocol    = var.flask_protocol
    cidr_blocks = var.flask_cidr_blocks
  }

  # SSH access to EC2
  ingress {
    description = var.ssh_description
    from_port   = var.ssh_from_port
    to_port     = var.ssh_to_port
    protocol    = var.ssh_protocol
    cidr_blocks = var.ssh_cidr_blocks
  }

  # PostgreSQL access for RDS
  ingress {
    description = var.rds_description
    from_port   = var.rds_from_port
    to_port     = var.rds_to_port
    protocol    = var.rds_protocol
    cidr_blocks = var.rds_cidr_blocks
  }

  # Allow all outbound traffic
  egress {
    description = var.outbound_description
    from_port   = var.outbound_from_port
    to_port     = var.outbound_to_port
    protocol    = var.outbound_protocol
    cidr_blocks = var.outbound_cidr_blocks
  }
}
