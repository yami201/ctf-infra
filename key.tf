resource "tls_private_key" "rsa_key" {
  count     = var.subnet_count
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  count    = var.subnet_count
  filename = "${path.module}/keys/ctf-key-${count.index}.pem"
  content  = tls_private_key.rsa_key[count.index].private_key_pem
}

resource "aws_key_pair" "key_pair" {
  count      = var.subnet_count
  key_name   = "ctf-key-${count.index}"
  public_key = tls_private_key.rsa_key[count.index].public_key_openssh
}