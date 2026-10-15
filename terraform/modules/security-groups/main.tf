resource "aws_security_group" "alb" {
    name = "${var.app_name}-alb-sg"
    description = "Allow HTTP and HTTPS traffic to the ALB"
    vpc_id = var.vpc_id

    ingress {
        description = "Allow HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Allow HTTPs"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "Allow outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "${var.app_name}-alb-sg"
    }
}

resource "aws_security_group" "ec2" {
    name = "${var.app_name}-ec2-sg"
    description = "Allow application traffic only from the ALB"
    vpc_id = var.vpc_id

    ingress {
        description = "Allow app traffic from ALB"
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        security_groups = [aws_security_group.alb.id]
    }

    ingress {
        description = "Allow ssh using my_ip"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    egress {
        description = "Allow outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.app_name}-ec2-sg"
    }
}