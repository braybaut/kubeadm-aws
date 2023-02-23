resource "aws_instance" "node" {
  for_each = { for node in var.kubernetes_nodes : node.name => node }
  ami      = data.aws_ami.ubuntu.id

  instance_type               = var.worker_type
  subnet_id                   = aws_subnet.private[each.value.subnet_name].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_cluster.id]
  key_name                    = var.key_name
  user_data                   = file("user-data.sh")

  tags = {
    Name = "${each.value.name}-${var.owner}"
  }

}

resource "aws_security_group" "allow_cluster" {
  name        = "allow_cluster"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.allow_bastion.id]
  }
  ingress {
    description = "from bastion"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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
    Name = "allow_cluster_access-${var.owner}"
  }
}


