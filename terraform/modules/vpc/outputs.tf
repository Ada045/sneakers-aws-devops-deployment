output "aws_vpc_id" {
  value = aws_vpc.sneakers-app-vpc.id
}

output "subnet_a_id" {
  value = aws_subnet.sneakers-app-subnet-a.id
}

output "subnet_b_id" {
  value = aws_subnet.sneakers-app-subnet-b.id
}