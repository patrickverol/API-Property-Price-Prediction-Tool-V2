resource "aws_instance" "ec2_flask" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.flask_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile_v2.name
  depends_on = [aws_s3_bucket.project_ml_bucket]

  tags = {
    ProjectName = var.project_name
    Label       = var.label
    Name        = var.ec2_flask_tag
  }
}
