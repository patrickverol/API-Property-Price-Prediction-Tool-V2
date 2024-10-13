resource "aws_s3_bucket" "project_ml_bucket" {
  bucket = "${var.project_name}-${var.personal_id}-${var.bucket_name}"

  depends_on = [null_resource.init_db, aws_instance.ec2_fastapi]

  tags = {
    ProjectName = var.project_name
    Label       = var.label
    BucketTag   = var.bucket_tag
  }

  provisioner "local-exec" {
    command = "${path.module}/upload_to_s3.sh"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://ml-api-369199697991-bucket-ml-files --recursive"
  }
}
