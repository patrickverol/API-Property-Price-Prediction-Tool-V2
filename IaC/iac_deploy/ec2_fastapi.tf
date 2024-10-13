resource "aws_instance" "ec2_fastapi" {
  ami = var.ami_fastapi
  instance_type = var.instance_type
  subnet_id = aws_subnet.private_subnet_a.id
  vpc_security_group_ids = [aws_security_group.fastapi_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile_v2.name
  key_name = aws_key_pair.generated_key.key_name

  provisioner "local-exec" {
    command = "echo \"AWS_EC2_FASTAPI_IP='${aws_instance.ec2_fastapi.private_ip}'\" >> ../frontend/.env"
  }

  tags = {
    ProjectName = var.project_name
    Label       = var.label
    Name        = var.ec2_fastapi_tag
  }
}
