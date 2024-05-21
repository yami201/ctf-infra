resource "aws_security_group" "allow_all_traffic" {
  name        = "allow_all_traffic"
  description = "Allow all kinds of traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_traffic"
  }

  depends_on = [aws_vpc.custom_vpc]
}

resource "aws_security_group" "ssh-access" {
  name        = "ssh-access"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_vpc.custom_vpc]
}