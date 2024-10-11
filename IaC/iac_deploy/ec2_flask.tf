resource "aws_instance" "ec2_flask" {
  ami = var.ami
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile_v2.name
  vpc_security_group_ids = [aws_security_group.ml_api_sg.id]
  depends_on = [aws_s3_bucket.project_ml_bucket, aws_instance.ec2_fastapi]

  # Startup script
  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -yp python3 python3-pip awscli
                sudo mkdir /frontend
                sudo aws s3 sync s3://ml-api-369199697991-bucket-ml-files/frontend /frontend
                cd /frontend
                sudo pip3 install flask python-dotenv gunicorn httpx
                nohup gunicorn -w 4 -b 0.0.0.0:5000 flask_app:app &
              EOF

  tags = {
    ProjectName = var.project_name
    Label       = var.label
    ec2_Tag     = var.ec2_flask_tag
  }
}
