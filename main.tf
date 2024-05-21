resource "aws_instance" "ctf-target" {
  count                       = var.subnet_count
  ami                         = var.target-ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.custom_subnet[count.index].id
  vpc_security_group_ids      = [aws_security_group.ssh-access.id, aws_security_group.allow_all_traffic.id]
  key_name                    = aws_key_pair.key_pair[count.index].key_name
  associate_public_ip_address = true

  tags = {
    Name = "ctf-target-${count.index+1}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo echo \"This is your user flag: ${random_uuid.user_flag[count.index].result}\" > /var/www/html/jabc/flag.txt",
      "sudo echo \"This is your root flag: ${random_uuid.root_flag[count.index].result}\" > /root/flag.txt",
      "sudo sed -i 's/<flag>/${random_uuid.web_flag[count.index].result}/g' /var/www/html/index.html"
    ]
    connection {
      type        = "ssh"
      user        = "root"
      private_key = tls_private_key.rsa_key[count.index].private_key_pem
      password    = "emi2024"
      host        = self.public_ip
    }

  }

  depends_on = [
    aws_key_pair.key_pair,
    local_file.private_key,
    aws_security_group.ssh-access,
    aws_security_group.allow_all_traffic,
    aws_subnet.custom_subnet,
    aws_vpc.custom_vpc
  ]
}

resource "aws_instance" "ctf-attack" {
  count                       = var.subnet_count
  ami                         = var.attack-ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.custom_subnet[count.index].id
  vpc_security_group_ids      = [aws_security_group.allow_all_traffic.id, aws_security_group.ssh-access.id]
  key_name                    = aws_key_pair.key_pair[count.index].key_name
  associate_public_ip_address = true

  tags = {
    Name = "ctf-attack-${count.index+1}"
  }

  depends_on = [
    aws_key_pair.key_pair,
    local_file.private_key,
    aws_security_group.allow_all_traffic,
    aws_security_group.ssh-access,
    aws_subnet.custom_subnet,
    aws_vpc.custom_vpc
  ]

}

