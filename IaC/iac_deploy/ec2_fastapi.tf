resource "aws_instance" "ec2_fastapi" {
  ami = var.ami
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile_v2.name
  vpc_security_group_ids = [aws_security_group.ml_api_sg.id]
  depends_on = [aws_s3_bucket.project_ml_bucket]

  # Startup script
  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -yp python3 python3-pip awscli
                sudo mkdir /backend
                sudo aws s3 sync s3://ml-api-369199697991-bucket-ml-files/backend /backend
                cd /backend
                sudo pip3 install uvicorn fastapi joblib scikit-learn psycopg2-binary pydantic python-dotenv
                nohup uvicorn backend_api:app --host 0.0.0.0 --port 5001 &
              EOF

  provisioner "local-exec" {
    command = <<EOT
      echo "AWS_EC2_FASTAPI_DNS=${aws_instance.ec2_fastapi.public_dns}" >> ../frontend/.env
    EOT
  }

  tags = {
    ProjectName = var.project_name
    Label       = var.label
    ec2_Tag     = var.ec2_fastapi_tag
  }
}