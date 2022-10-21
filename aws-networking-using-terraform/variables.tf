# aws region variables
variable "aws_region" {
    description = "region for infrastructure"
    type = string
    default = "us-east-1"  
}

# aws vpc variables
variable "clxdev_vpc_cidr_block" {
    description = "cidr block range for vpc"
    type = string
    default = "192.168.0.0/16"
}

variable "vpc_tag" {
    description = "tag name for vpc"
    type = string
    default = "clxdex-vpc-tag"  
}

# private subnet variables
variable "cidr_priv_subnet" {
    description = "cidr block range for private subnet"
    type = string
    default = "192.168.1.0/24"
}

variable "subnet_priv_tag" {
    description = "tag name for private subnet"
    type = string
    default = "clxdev-private-subnet-tag"
}

# public subnet variables
variable "cidr_pub_subnet" {
    description = "cidr block range for public subnet"
    type = string
    default = "192.168.0.0/24"
}

variable "subnet_pub_tag" {
    description = "tag name for public subnet"
    type = string
    default = "clxdev-public-subnet-tag"  
}

# internet gateway variables
variable "igw_tag" {
    description = "tag name for internet gateway"
    type = string
    default = "clxdev-internet-gateway-tag"
}

# route table variables -- public
variable "cidr_pub_rt" {
    description = "cidr block range for public route table"
    type = string
    default = "0.0.0.0/0"
}

variable "pub_rt_tag" {
    description = "tag name for public route table"
    type = string
    defualt = "clxdev-public-route-table-tag"
}

# NAT Gateway Variable
variable "nat_gw_tag" {
    description = "tag name for nat gateway"
    type = string
    default = "clxdev-nat-gateway-tag"
}

# route table variables -- private
variable "cidr_priv_rt" {
    description = "cidr block range for private route table"
    type = string
    default = "0.0.0.0/0"
}

variable "priv_rt_tag" {
    description = "tag name for private route table"
    type = string
    default = "clxdev-private-route-table-tag"
}

# security group variables -- bastion ssh
variable "bastion_sg_name" {
    description = "name of bastion"
    type = string
    default = "bastion_ssh"  
}

variable "bastion_sg_tag" {
    description = "tag name for bastion security group rule"
    type = string
    default = "clxdev-bastion-ssh-tag"
}

# ec2 instance variables -- bastion host
variable "bastion_ami" {
    description = "ami for bastion host"
    type = string
    default = ""
}

variable "bastion_instance_type" {
    description = "instance type for bastion host"
    type = string
    default = "t2.micro"
}

variable "bastion_instance_tag" {
    description =  "tag name for bastion host"
    type = string
    default = "clxdev-bastion-host"
}

# security group variables -- wordpress http
variable "wp_sg_name" {
    description = "name for wordpress security group"
    type = string
    default = "wp_http"
}

variable "wp_http_sg_tag" {
    description = "tag name for wordpress security group"
    type = string
    default = "clxdev-wp-http-tag"
}


# ec2 instance variables -- wordpress host
variable "wp_ami" {
    description = "ami for wordpress host"
    type = string
    default = ""
}

variable "bastion_instance_type" {
    description = "instance type for wordpress host"
    type = string
    default = "t2.micro"
}

variable "wp_instance_tag" {
    description = "tag name for wordpress host"
    type = string
    default = "clxdev-wordpress-host"
}

# security group -- mysql
variable "mysql_sg_name" {
    description = "name for mysql security group"
    type = string
    default = "sg_mysql"
}

variable "mysql_sg_tag" {
    descriptio = "tag name for mysql security group"
    type = string
    default = "clxdev-mysql-tag"
}

# ec2 instance variables -- mysql server
variabe "mysql_server_ami" {
    description = "ami for mysql server"
    type = string
    default = ""
}

variable "mysql_server_instnace_type" {
    description = "instance type for mysql server"
    type = string
    default = "t2.micro" 
}

variable "mysql_server_tag" {
    description = "tag name for mysql server"
    type = string
    default = "clxdev-mysql-server-tag"
}
