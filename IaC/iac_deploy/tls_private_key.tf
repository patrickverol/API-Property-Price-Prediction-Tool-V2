resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "generated_key" {
  key_name   = "my_private_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key" {
  filename = "${path.module}/my_private_key.pem"
  content  = tls_private_key.ssh_key.private_key_pem
  file_permission = "0400"
}
