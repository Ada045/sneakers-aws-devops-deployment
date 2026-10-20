output "instance_a_id" {
  value = aws_instance.sneakers-app-server-a.id
}

output "instance_b_id" {
  value = aws_instance.sneakers-app-server-b.id
}

output "instance_a_public_ip" {
  value = aws_instance.sneakers-app-server-a.public_ip
}

output "instance_b_public_ip" {
  value = aws_instance.sneakers-app-server-b.public_ip
}