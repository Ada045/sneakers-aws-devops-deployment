data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name   = var.key_name
  public_key = file(var.public_key_location)
}

resource "aws_instance" "sneakers-app-server-a" {
  ami                         = data.aws_ami.amazon-linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_a_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.instance_profile_name
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name

  user_data = file("./entry-script.sh")
  
  root_block_device {
    volume_size = 12
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.app_name}-server-a"
  }
}

resource "aws_instance" "sneakers-app-server-b" {
  ami                         = data.aws_ami.amazon-linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_b_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.instance_profile_name
  associate_public_ip_address = true
  key_name                    = var.key_name

  user_data = file("./entry-script.sh")

  root_block_device {
    volume_size = 12
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.app_name}-server-b"
  }
}