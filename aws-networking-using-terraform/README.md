# Terraform -- Learn by Building --- AWS Networking using Terraform

# Overview

Found new infrastructure to build. This will allow me to get some hands on experience with different AWS services using Terraform. Following this [guide](https://developer-shubham-rasal.medium.com/aws-networking-using-terraform-cbbf28dcb124) will give me a better understanding using different AWS Services along with Terraform Infrastructure and AWS Architecture.

-----

# Getting Started

Creating VPC, subnets, Internet Gateway, NAT Gateway, Route Table, Bastion host, Servers.

***What do we want to do?***

`Statement`: We have to create a web portal for our company with all the security as much as possible. So, we use the WordPress software with a dedicated database server.

The database should not be accessible from the outside world for security purposes. We only need public WordPress for clients. So here are the steps for proper understanding!

----

## Steps:

1. Write an Infrastructure as code using Terraform, which automatically creates a VPC.

2. In that VPC we have to create 2 subnets:

        a) public subnet [ Accessible for Public World! ]

        b) private subnet [ Restricted for Public World! ]

3. Create a public-facing internet gateway to connecting our VPC/Network to the internet world and attach this gateway to our VPC.

4. Create a routing table for Internet gateway so that instance can connect to outside world, update and associate it with the public subnet.

5. Create a NAT gateway to connecting our VPC/Network to the internet world and attach this gateway to our VPC in the public network

6. Update the routing table of the private subnet, so that to access the internet it uses the NAT gateway created in the public subnet

7. Launch an ec2 instance that has WordPress setup already having the security group allowing port 80 so that our client can connect to our WordPress site. Also, attach the key to the instance for further login into it.

8. Launch an ec2 instance that has MYSQL setup already with security group allowing port 3306 in a private subnet so that our WordPress VM can connect with the same. Also, attach the key with the same.

`Note`: WordPress instance has to be part of the public subnet so that our client can connect our site. MySQL instance has to be part of a private subnet so that the outside world can’t connect to it.

Don’t forget to add auto IP assign and auto DNS name assignment options to be enabled.

----

# Architecture
![architecture](https://miro.medium.com/max/1400/1*Hy49UXLsRfu7e_uauBp5Mg.png)

---

# Pre-requisite

- AWS account
- [Download AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html) and [Configure it](https://medium.com/@developer.shubham.rasal/create-aws-ec2-instance-using-terraform-3a3a2d273048).
- Download [terraform](https://www.terraform.io/downloads.html).

----

# Documentation

1. Configure the Provider
2. Create VPC && Create two Subnet in VPC - Private/Public
   - code creates VPC with given cider block, the tenancy is default and we want DNS hostname URL for that we are enabling it. VPC will create in the region you have mentioned in the above provider resource.
   - Here we are just creating two subnets and we named public and private. A VPC spans all of the Availability Zones in the Region. After creating a VPC, we want to add subnets in two different Availability Zone. will create two subnets named ‘public_subnet’ and ‘private_subnet’ in `‘us-east-1a’` and `‘us-easts-1b’`
3. Create Internet Gateway
   - An internet gateway is a horizontally scaled, redundant, and highly available VPC component that allows communication between your VPC and the internet. [Read More](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html)
   - we want to connect our VPC to the internet so that’s why we need to create Internet Gateway.
4. Create a Route Table
   - A route table contains a set of rules, called routes, that are used to determine where network traffic from your subnet or gateway is directed.
   - to create a route table we have use `aws_route_table` resource. We want to access the internet so add cider_block to `0.0.0.0/0` , (quad-zero route) and use the internet gateway that we create above. The destination for the route is, which represents all IPv4 addresses. The target is the internet gateway that's attached to your VPC.
   - To read more about the Route table you can refer to this. [ROUTE_TABLE](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)
5. Associate Route table with Public Subnet
   - Now we want to use the internet only for public subnet so associate route table with that subnet only. To do this we will use `aws_route_table_association` resource in terraform which takes subnet id and route table id. 

> Now we have created VPC and created two subnets in different Availability Zones in the region and given Internet connection by creating an Internet gateway for VPC. Now lets launch instances of WordPress and MySQL.

6. Create NAT Gateway
   - A Network Address Translation (NAT) gateway is a device that helps enabling EC2 instances in a private subnet to connect to the Internet and prevent the Internet from start off a connection with those instances.
   1. Create EIP for NAT Gateway
   2. NAT Gateway
   - Create NAT gateway using aws_nat_gateway resource of terraform. NAT gateway should be in public subnet and it requires EIP so that it can rapidly remap the address in case of failure. 
7. Create Route Table for private subnet and NAT gateway
   - As per need, we want to get internet connection in a private subnet so that we create one more route table with nat gateway.
8. Associate Route Table to the private subnet.
   - create association between route table which has NAT gateway and private subnet.

> We want to use database instance which is in a private subnet that’s why we can not access it through ssh from our machine/internet. If we want to connect and manage instances in private subnet we have to create one more instance which will configure and manages instances in VPC. that instance is called as bastion host or Jump Server
9. Create a Security Group for Bastion Host or Jump Server
   -  This security group is created for the bastion host and allow only ssh requests.
10. Create Bastion Host or Jump Server in Public subnet
    -  Create an instance for bastion host in a public subnet, assign public IP and give Security Group that we have created allowing the only ssh.
11. Create a Security group which allow HTTP and SSH for Bastion Host
    -  we have created one more security group which allows http inbound traffic from anywhere but ssh only from bastion host security group.
12. Create WordPress Instance in the public subnet
    -  Create an instance for your web portal in public subnet allowing https and ssh security group. Here I have used amazon Linux and attach keypair that we have created. Also, assign public IP using that we can request this server.
13. Create a Security Group for MySQL and SSH for Bastion Host
    -  Our Mysql server will be a private subnet. we want to open this server only for MySQL requests and ssh from the bastion host. Hence allow inbound/ingress for MySQL and ssh for bastion host only.
14. Create MYSQL Server in a private subnet
    -  Create MySQL server in the private subnet.attach keypair and give security group that we have created for this instance.

---

# Conclusion

We can successfully ping to the outside world through MySQL instance in the private subnet.

Now, using bastion host you can configure webservers and database servers that we have created above. You can install WordPress on EC2 instance in the public subnet and install database service in the instance on private subnet which can go to the internet via NAT gateway.

We have successfully created Infrastructure as Code for VPC in AWS for classic VPC i.e VPC with Public and Private Subnets.

----

[tfhome](https://www.terraform.io)
[tfdocs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
[medium](https://medium.com/)

