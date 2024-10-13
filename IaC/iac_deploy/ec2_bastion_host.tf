resource "aws_instance" "bastion" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile_v2.name
  depends_on = [aws_s3_bucket.project_ml_bucket]
  key_name = aws_key_pair.generated_key.key_name  # Attach the key here

  provisioner "file" {
    source      = "${path.module}/my_private_key.pem"
    destination = "/home/ec2-user/my_private_key.pem"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = aws_instance.bastion.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",
      "set -e",
      "echo 'Checking key file permissions...'",
      "ls -l /home/ec2-user/my_private_key.pem",
      "chmod 400 /home/ec2-user/my_private_key.pem",
      "echo 'Key file permissions after chmod:'",
      "ls -l /home/ec2-user/my_private_key.pem",
      
      "echo 'FastAPI instance private IP: ${aws_instance.ec2_fastapi.private_ip}'",
      "echo 'Attempting SSH connection to FastAPI instance...'",
      "ssh -o StrictHostKeyChecking=no -i /home/ec2-user/my_private_key.pem ec2-user@${aws_instance.ec2_fastapi.private_ip} 'echo SSH connection successful'",
      
      "echo 'Downloading backend files from S3...'",
      "ssh -o StrictHostKeyChecking=no -i /home/ec2-user/my_private_key.pem ec2-user@${aws_instance.ec2_fastapi.private_ip} '",
      "sudo mkdir /backend",
      "sudo aws s3 sync s3://ml-api-369199697991-bucket-ml-files/backend /backend",
      
      "echo 'Creating the database...'",
      "echo 'Attempting to execute database creation command...'",
      "ssh -o StrictHostKeyChecking=no -i /home/ec2-user/my_private_key.pem ec2-user@${aws_instance.ec2_fastapi.private_ip} 'PGPASSWORD=Vasco.123 psql --host=${aws_db_instance.rds_db.address} --port=5432 --username=postgres --dbname=postgres --file=/backend/create_database.sql'",
      
      "echo 'Database creation commands executed.'",

      "echo 'Setting up FastAPI instance...'",
      "cd /backend",
      "nohup uvicorn backend_api:app --host 0.0.0.0 --port 5001 &",
      "'"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = aws_instance.bastion.public_ip
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm my_private_key.pem"
  }  

  tags = {
    ProjectName = var.project_name
    Label       = var.label
    Name        = "BastionHost"
  }
}
