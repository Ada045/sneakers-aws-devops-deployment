output "alb-sg-id" {
    value = aws_security_group.alb.id
}

output "ec2-sg-id" {
    value = aws_security_group.ec2.id
}