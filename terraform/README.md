# Sneakers E-Commerce Infrastructure with Terraform

## Project Overview

I initially deployed this sneakers e-commerce application by creating and configuring the AWS resources manually. Although the application worked, recreating the infrastructure or making changes would require repeating several steps and configuring each resource individually.

I introduced **Terraform** to manage the infrastructure as code. This allowed me to define my AWS resources in configuration files, organise them into reusable modules, and provision the infrastructure in a more consistent and repeatable way. It also made infrastructure changes easier to review before applying them, rather than relying entirely on manual configuration through the AWS Console.

Using Terraform, I structured the infrastructure into modules for networking, EC2 instances, IAM, security groups, and load balancing. I also used **EC2 User Data** to automate the initial server setup by installing Docker, Docker Compose, and the AWS CLI when the instances launched.

The application runs in Docker containers on two EC2 instances across different Availability Zones, with an Application Load Balancer distributing incoming traffic.

This project demonstrates how I moved from manually provisioning cloud infrastructure towards a more automated, maintainable, and repeatable approach using Infrastructure as Code.

## Architecture

**User → Custom Domain → Application Load Balancer → EC2 Instances → MongoDB Atlas**

## What I Built

- **VPC:** Created the network infrastructure with two public subnets across different Availability Zones.
- **EC2:** Deployed two application servers to run the sneakers website.
- **EC2 User Data:** Automated the initial installation of Docker, Docker Compose, and the AWS CLI on instance launch.
- **Docker & Docker Compose:** Containerised and ran the application on both servers.
- **Amazon ECR:** Stored the application's Docker image.
- **Application Load Balancer:** Distributed traffic between the instances and performed health checks.
- **Security Groups:** Controlled traffic between the load balancer and application servers.
- **IAM:** Configured instance permissions for accessing Amazon ECR.
- **ACM:** Used an SSL/TLS certificate to enable HTTPS for the custom domain.
- **MongoDB Atlas:** Hosted the application's database.

## What This Project Demonstrates

- Infrastructure as Code with Terraform
- Modular AWS infrastructure design
- Automated EC2 instance configuration using User Data
- Containerised application deployment across multiple EC2 instances
- Load balancing across Availability Zones
- AWS networking, IAM, and security configuration
- HTTPS configuration for a custom domain

**Technologies:** Terraform, AWS, EC2, VPC, IAM, ECR, Docker, Docker Compose, ALB, ACM, MongoDB Atlas.

**Repository:** [sneakers-aws-devops-deployment](https://github.com/Ada045/sneakers-aws-devops-deployment)
