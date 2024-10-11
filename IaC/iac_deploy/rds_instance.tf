resource "aws_db_instance" "rds_db" {
  allocated_storage      = var.db_allocated_storage
  engine                 = var.db_engine
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.ml_api_sg.id]
  skip_final_snapshot    = var.db_skip_final_snapshot
  publicly_accessible    = var.db_publicly_accessible
  tags = {
    ProjectName = var.project_name
    Label       = var.label
    db_Tag      = var.db_tag
  }
}
