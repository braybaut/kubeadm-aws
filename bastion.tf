resource "aws_instance" "bastion" {
  ami = data.aws_ami.ubuntu.id

  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public["public_1"].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_bastion.id]
  key_name                    = var.key_name

  tags = {
    Name = "Bastion-host-${var.owner}"
  }

}

resource "aws_security_group" "allow_bastion" {
  name        = "allow_bastion"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "from internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_bastion_access-${var.owner}"
  }
}
