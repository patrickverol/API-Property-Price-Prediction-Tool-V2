output "instance_public_ip_flask" {
  value = aws_instance.ec2_flask.public_ip
}

output "instance_private_ip_fastapi" {
  value = aws_instance.ec2_fastapi.private_ip
}

output "rds_endpoint" {
  value = aws_db_instance.rds_db.address
}

output "private_key_pem" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true  # This hides the key from output during Terraform apply
}

output "public_key_openssh" {
  value = tls_private_key.ssh_key.public_key_openssh
}