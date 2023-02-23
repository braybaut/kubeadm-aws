output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "worker_nodes_private_ip" {
  value = { for k, v in aws_instance.node : k => v.private_ip }
}
