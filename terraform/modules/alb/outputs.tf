output "alb_dns_anme" {
    value = aws_lb.sneakers-lb.dns_name
}

output "alb_zone_id" {
    value = aws_lb.sneakers-lb.zone_id
}

output "target_group_arn" {
    value = aws_lb_target_group.sneakers-target-group.arn
}