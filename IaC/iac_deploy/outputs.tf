output "instance_public_dns_flask" {
  value = aws_instance.ec2_flask.public_dns
}

output "instance_public_dns_fastapi" {
  value = aws_instance.ec2_fastapi.public_dns
}

output "rds_endpoint" {
  value = aws_db_instance.rds_db.address
}