#!/bin/bash
sudo dnf update -y
sudo dnf install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL \
  "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
sudo dnf install -y awscli
sudo dnf install -y https://s3.eu-west-1.amazonaws.com/amazon-ssm-eu-west-1/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable --now amazon-ssm-agent
aws ecr get-login-password --region eu-west-1 | sudo docker login --username AWS --password-stdin 926337676555.dkr.ecr.eu-west-1.amazonaws.com
mkdir -p /home/ec2-user/sneakers-app
sudo chown ec2-user:ec2-user /home/ec2-user/sneakers-app
