provider "aws" {
    region = var.aws_region
}

module "sneakers-vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    app_name = var.app_name
    subnet-a = var.subnet-a
    subnet-b = var.subnet-b
}

module "sneakers-sg" {
    source = "./modules/security-groups"
    vpc_id = module.sneakers-vpc.aws_vpc_id
    app_name = var.app_name
    my_ip = var.my_ip
}

module "iam" {
    source = "./modules/iam"
    app_name = var.app_name
}

module "ec2" {
    source = "./modules/ec2"
    instance_type = var.instance_type
    security_group_id = module.sneakers-sg.ec2-sg-id
    instance_profile_name = module.iam.instance_profile_name
    app_name = var.app_name
    subnet_a_id = module.sneakers-vpc.subnet_a_id
    subnet_b_id = module.sneakers-vpc.subnet_b_id
    public_key_location = var.public_key_location
    key_name = var.key_name
}

module "alb" {
    source = "./modules/alb"
    app_name = var.app_name
    alb_sg_id = module.sneakers-sg.alb-sg-id
    subnet_a_id = module.sneakers-vpc.subnet_a_id
    subnet_b_id = module.sneakers-vpc.subnet_b_id
    vpc_id = module.sneakers-vpc.aws_vpc_id
    instance_a_id = module.ec2.instance_a_id
    instance_b_id = module.ec2.instance_b_id
    acm_certificate_arn = var.acm_certificate_arn
}

output "instance_a_public_ip" {
    value = module.ec2.instance_a_public_ip
}

output "instance_b_public_ip" {
    value = module.ec2.instance_b_public_ip
}