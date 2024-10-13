# General variables
project_name = "ml-api"
label        = "version-01"
personal_id  = "369199697991"
region       = "us-east-2"

# EC2 instance variables
ami            = "ami-0a0d9cf81c479446a"
ami_fastapi = "ami-06f7db4d07f83825a"
instance_type  = "t2.micro"
ec2_flask_tag = "EC2-Flask"
ec2_fastapi_tag = "EC2-Fastapi"


# S3 bucket variables
bucket_name = "bucket-ml-files"
bucket_tag = "bucket-ml-files"


# RDS Variables
db_allocated_storage      = 20
db_engine                 = "postgres"
db_instance_class         = "db.t3.micro"
db_name                   = "postgres"
db_username               = "postgres"
db_password               = "Vasco.123"
db_skip_final_snapshot    = true
db_publicly_accessible    = false
db_tag = "Save-Request-Data"


# Security Groups Variables
sg_name        = "ml_api_sg"
sg_description = "Security Group for Flask App in EC2"

# HTTP traffic for Flask App
http_description = "Inbound Rule 1 - HTTP traffic for Flask App"
http_from_port   = 80
http_to_port     = 80
http_protocol    = "tcp"
http_cidr_blocks = ["0.0.0.0/0"]

# Fastapi App
fastapi_description = "Inbound Rule 2 - Fastapi App"
fastapi_from_port   = 5001
fastapi_to_port     = 5001
fastapi_protocol    = "tcp"
fastapi_cidr_blocks = ["0.0.0.0/0"]

# Flask App
flask_description = "Inbound Rule 3 - Flask App"
flask_from_port   = 5000
flask_to_port     = 5000
flask_protocol    = "tcp"
flask_cidr_blocks = ["0.0.0.0/0"]

# SSH access to EC2
ssh_description = "Inbound Rule 4 - SSH access to EC2"
ssh_from_port   = 22
ssh_to_port     = 22
ssh_protocol    = "tcp"
ssh_cidr_blocks = ["0.0.0.0/0"]

# PostgreSQL access for RDS
rds_description = "Inbound Rule 5 - PostgreSQL access for RDS"
rds_from_port   = 5432
rds_to_port     = 5432
rds_protocol    = "tcp"
rds_cidr_blocks = ["0.0.0.0/0"] # Optionally restrict this to specific IPs

# Allow all outbound traffic
outbound_description = "Outbound Rule"
outbound_from_port = 0
outbound_to_port = 65535
outbound_protocol = "tcp"
outbound_cidr_blocks = ["0.0.0.0/0"]