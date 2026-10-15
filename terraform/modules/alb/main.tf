resource "aws_lb" "sneakers-lb" {
    name = "${var.app_name}-alb"
    internal = false
    load_balancer_type = "application"

    security_groups = [var.alb_sg_id]

    subnets = [
        var.subnet_a_id,
        var.subnet_b_id
    ]

    tags = {
        Name = "${var.app_name}-alb"
    }
}

resource "aws_lb_target_group" "sneakers-target-group" {
    name = "${var.app_name}-tg"
    port = 5000
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
      path = "/"
      protocol = "HTTP"
      matcher = "200-399"
      interval = 30
      healthy_threshold = 2
      unhealthy_threshold = 3
    }

    tags = {
        Name = "${var.app_name}-tg"
    }
}

resource "aws_lb_target_group_attachment" "sneakers-app-a" {
    target_group_arn = aws_lb_target_group.sneakers-target-group.arn
    target_id = var.instance_a_id
    port = 5000
}

resource "aws_lb_target_group_attachment" "sneakers-app-b" {
    target_group_arn = aws_lb_target_group.sneakers-target-group.arn
    target_id = var.instance_b_id
    port = 5000
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.sneakers-lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "redirect"

        redirect {
            port = "443"
            protocol = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}

resource "aws_lb_listener" "https" {
    load_balancer_arn = aws_lb.sneakers-lb.arn
    port = 443
    protocol = "HTTPS"
    certificate_arn = var.acm_certificate_arn
    ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.sneakers-target-group.arn
    }
}