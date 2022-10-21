# Terraform -- Learn by Building

# Overview

Found new infrastructure to build. This will allow me to get some hands on experience with different AWS services using Terraform. Following different guides I may find along the way will give me a better understanding using different AWS Services along with Terraform Infrastructure and Building Architecture in the cloud.

-----

# Getting Started

As new guides cross my path to assist in my knowledge and understanding of how the AWS Provider works and the best practices to build infrastructure using Terraform. I will update this repository as new tutorials become available for me to learn and use to gain more knowledge. The ***Guides*** portion of this README will be updated accordingly with links used to learn. This is done for future referencing and of course to give credit to the original owner.



----

## Guides
- [AWS Networking using Terraform](https://developer-shubham-rasal.medium.com/aws-networking-using-terraform-cbbf28dcb124)
- [How to Create Infrastructure on AWS for launching application](https://developer-shubham-rasal.medium.com/how-to-create-infrastructure-on-aws-for-launching-application-103d673f4a87)
- [Launching Web Application with AWS using Terraform and Git](https://developer-shubham-rasal.medium.com/launching-web-application-with-aws-using-terraform-and-git-fd7484922e4d)
- [Creating a simple EC2 instance webserver which will clone code from our GitHub repository](https://developer-shubham-rasal.medium.com/launching-aws-ec2-webserver-instance-in-terraform-8e219fe7be66)
- [Create AWS EC2 Instance using Terraform](https://developer-shubham-rasal.medium.com/create-aws-ec2-instance-using-terraform-3a3a2d273048)
- [Create an Nginx instance in AWS using Terraform](https://awstip.com/how-to-create-an-nginx-instance-in-aws-using-terraform-feb6af12749a)

----
## Running Terraform

Run the following to ensure ***terraform*** will only perform the expected
actions:

```sh
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

## Tearing Down the Terraform Infrastructure

Run the following to verify that ***terraform*** will only impact the expected
nodes and then tear down the cluster.

```sh
terraform plan
terraform destroy
```

## Module Structure

Terraform treats any local directory referenced in the source argument of a module block as a module. A typical file structure for a new module is:

```sh
.
├── LICENSE
├── README.md
├── main.tf
├── modules
│   └── corresponding-naming-of-used-modules
├── outputs.tf
├── terraform.tfstate
├── terraform.tfstate.backup
└── variables.tf
```
---

# Documentation

### The name of the resources will follow a pattern:

- Cloud: a prefix specifying the unique name of this cloud across all available clouds and providers. In this case the prefix will be: `clxdev` that stands for ***Cloud Logix Developer*** in lowercase.
- Resource: a short name identifying the resource, in this case:
    -    rt: for routing table
    -    igw: for Internet gateway
    -    ir: for Internet route
- Visibility: for resources that can be either public or private, a 3 letter acronym for the visibility:
    -    pub: for public resources
    -    pri: for private resources
- Name: optional a name that describes the usage of the resource, for example the routing tables for private
zones A and B will be za and zb.




---
[tfhome](https://www.terraform.io)
[tfdocs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
[medium](https://medium.com/)