# Null resource to run the SQL script after RDS is created
resource "null_resource" "init_db" {
  depends_on = [aws_db_instance.rds_db]

  provisioner "local-exec" {
    command = "echo \"DB_HOST='${aws_db_instance.rds_db.address}'\" > ../backend/.env && echo \"DB_NAME='postgres'\" >> ../backend/.env && echo \"DB_USER='postgres'\" >> ../backend/.env && echo \"DB_PASS='Vasco.123'\" >> ../backend/.env"
  }

  # Ensure the RDS instance is fully initialized before executing the command
  triggers = {
    db_instance_address = aws_db_instance.rds_db.address
  }
}
