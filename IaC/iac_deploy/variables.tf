# General Variables
variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "label" {
  description = "The version of the project."
  type        = string
}

variable "personal_id" {
  description = "The number of the personal id on AWS."
  type        = string
}

variable "region" {
  description = "The region to deploy the project"
  type        = string
}


# EC2 Variables
variable "ami" {
  description = "The ID of the AMI to use for the EC2 instance."
  type        = string
}

variable "ami_fastapi" {
  description = "The ID of the AMI to use for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to use."
  type        = string
}

variable "ec2_flask_tag" {
  description = "A map of tags to assign to the EC2 instance."
  type        = string
}

variable "ec2_fastapi_tag" {
  description = "A map of tags to assign to the EC2 instance."
  type        = string
}


# S3 Variables
variable "bucket_name" {
  description = "The name of the S3 bucket to create."
  type        = string
}

variable "bucket_tag" {
  description = "Tags to identify the project"
  type        = string
}


# RDS Variables
variable "db_allocated_storage" {
  description = "The size of the RDS storage in GB"
  type        = number
}

variable "db_engine" {
  description = "Database engine (e.g., postgres)"
  type        = string
  default     = "postgres"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "postgres"
}

variable "db_username" {
  description = "Username for the RDS database"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
}

variable "db_skip_final_snapshot" {
  description = "Indicates that if the RDS will get a snapshot when destroyed"
  type        = bool
}

variable "db_publicly_accessible" {
  description = "Indicates that if the RDS is acessible for public or not"
  type        = bool
}

variable "db_tag" {
  description = "A map of tags to assign to the RDS"
  type        = string
}


# Security Groups Variables
variable "sg_name" {
  description = "The name to identify the Security Group"
  type        = string
}

variable "sg_description" {
  description = "A description to identify the SEcurity Group."
  type        = string
}

# HTTP traffic for Flask App
variable "http_description" {type = string}
variable "http_from_port"   {type = number}
variable "http_to_port"     {type = number}
variable "http_protocol"    {type = string}
variable "http_cidr_blocks" {type = list(any)}

# Fastapi App
variable "fastapi_description" {type = string}
variable "fastapi_from_port"   {type = number}
variable "fastapi_to_port"     {type = number}
variable "fastapi_protocol"    {type = string}
variable "fastapi_cidr_blocks" {type = list(any)}

# Flask App
variable "flask_description" {type = string}
variable "flask_from_port"   {type = number}
variable "flask_to_port"     {type = number}
variable "flask_protocol"    {type = string}
variable "flask_cidr_blocks" {type = list(any)}

# SSH access to EC2
variable "ssh_description" {type = string}
variable "ssh_from_port"   {type = number}
variable "ssh_to_port"     {type = number}
variable "ssh_protocol"    {type = string}
variable "ssh_cidr_blocks" {type = list(any)}

# PostgreSQL access for RDS
variable "rds_description" {type = string}
variable "rds_from_port"   {type = number}
variable "rds_to_port"     {type = number}
variable "rds_protocol"    {type = string}
variable "rds_cidr_blocks" {type = list(any)}

# Allow all outbound traffic
variable "outbound_description" {type = string}
variable "outbound_from_port"   {type = number}
variable "outbound_to_port"     {type = number}
variable "outbound_protocol"    {type = string}
variable "outbound_cidr_blocks" {type = list(any)}