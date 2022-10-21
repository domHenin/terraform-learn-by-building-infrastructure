# 1. Create Provider
provider "aws" {
  region = var.aws_region
}

# 2a. Create VPC
resource "aws_vpc" "clxdev_vpc" {
  # cidr_block = var.vpc_cidr_block
  cidr_block = "192.168.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_tag
  }
}

# 2b. Create Private Subnet
resource "aws_subnet" "clxdev_subnet_pri" {
  vpc_id = aws_vpc.clxdev_vpc.id

  cidr_block        = var.cidr_priv_subnet
  availability_zone = "us-east-1b"

  tags = {
    "Name" = var.subnet_priv_tag
  }
}

# 2c. Create Public Subnet
resource "aws_subnet" "clxdev_subnet_pub" {
  vpc_id = aws_vpc.clxdev_vpc.id

  cidr_block              = var.cidr_pub_subnet
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = var.subnet_pub_tag
  }
}

# 3. Create Internet Gateway for outside connection with VPC
resource "aws_internet_gateway" "clxdev_igw" {
  vpc_id = aws_vpc.clxdev_vpc.id

  tags = {
    "Name" = var.igw_tag
  }
}

resource "aws_internet_gateway_attachment" "clxdev_attach_igw" {
  vpc_id              = aws_vpc.clxdev_vpc.id
  internet_gateway_id = aws_internet_gateway.clxdev_igw.id
}


# 4. Create Route Table
resource "aws_route_table" "clxdev_pub_rt" {
  vpc_id = aws_vpc.clxdev_vpc.id

  route {
    cidr_block = var.cidr_pub_rt
    gateway_id = aws_internet_gateway.clxdev_igw.id
  }

  tags = {
    "Name" = var.pub_rt_tag
  }
}

# 5. Associate Route table with Public Subnet
resource "aws_route_table_association" "clxdev_rt_pub_associate" {
  subnet_id      = aws_subnet.clxdev_subnet_pub.id
  route_table_id = aws_route_table.clxdev_pub_rt.id
}

# 6. Create NAT Gateway
# 6a. Create EIP for NAT Gateway
resource "aws_eip" "clxdev_nat_eip" {
  vpc = true
}

# 6b. NAT Gateway
resource "aws_nat_gateway" "clxdev_nat_gw" {
  allocation_id = aws_eip.clxdev_nat_eip.id
  subnet_id     = aws_subnet.clxdev_subnet_pub.id

  tags = {
    Name = var.nat_gw_tag
  }

  depends_on = [aws_internet_gateway.clxdev_igw]
}


# 7. Create Route Table for private subnet and NAT gateway
resource "aws_route_table" "clxdev_priv_rt" {
  vpc_id = aws_vpc.clxdev_vpc.id

  route {
    cidr_block = var.cidr_priv_rt
    gateway_id = aws_nat_gateway.clxdev_nat_gw.id
  }

  tags = {
    "Name" = var.priv_rt_tag
  }
}

# 8. Associate Route Table to the private subnet.
resource "aws_route_table_association" "clxdev_nat_priv_associate" {
  subnet_id      = aws_subnet.clxdev_subnet_pri.id
  route_table_id = aws_route_table.clxdev_priv_rt.id
}


// Create private key pair
# resource "tls_private_key" "webserver_private_key" {
#   algorithm = "RSA"
#   rsa_bits = 4096
# }

# resource "local_file" "private_key" {
#   content = tls_private_key.webserver_private_key.private_key_pem
#   filename = "webserver_key.pem"
#   file_permision = 0400
# }

// add private key to aws file
# resouce "aws_key_pair" "webserver_key" {
#   key_name = "webserver"
#   public_key = tls_private_key.webserver_private_key.public_key_openssh
# }


# 9. Create Security Group for Bastion Host or Jump Server
resource "aws_security_group" "clxdev_bastion_ssh" {
  name        = var.bastion_sg_name
  description = "Allow SSH"
  vpc_id      = aws_vpc.clxdev_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.bastion_sg_tag
  }
}

# 10. Create Bastion Host or Jump Server in Public Subnet
resource "aws_instance" "clxdev_bastion_host" {
  ami                         = var.bastion_ami
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.clxdev_subnet_pub.id
  vpc_security_group_ids      = [aws_security_group.clxdev_bastion_ssh.id]
  associate_public_ip_address = "true"

  tags = {
    Name = var.bastion_instance_tag
  }
}

# 11. Create a Security group which allow HTTP and SSH for Bastion Host
resource "aws_security_group" "clxdev_wp_http" {
  name        = var.wp_sg_name
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.clxdev_vpc.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "ssh"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.clxdev_bastion_ssh.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.wp_http_sg_tag
  }
}

# 12. Create WordPress Instance in the public subnet
resource "aws_instance" "clxdev_wordpress_host" {
  ami                         = var.wp_ami
  instance_type               = var.wp_instance_type
  subnet_id                   = aws_subnet.clxdev_subnet_pub.id
  # key_name                    = aws_key_pair.webserver_key.key_name
  vpc_security_group_ids      = [aws_security_group.clxdev_wp_http.id]
  associate_public_ip_address = "true"

  tags = {
    Name = var.wp_instance_tag
  }
}

# 13. Create a Security Group for MySQL and SSH for Bastion Host
resource "aws_security_group" "clxdev_sg_mysql" {
  name        = var.mysql_sg_name
  description = "Allow mysql inbound traffic"
  vpc_id      = aws_vpc.clxdev_vpc.id

  ingress {
    description     = "mysql"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.clxdev_wp_http.id]
  }

  ingress {
    description     = "ssh"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.clxdev_bastion_ssh.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.mysql_sg_tag
  }

  depends_on = [aws_security_group.clxdev_wp_http, aws_security_group.clxdev_bastion_ssh]
}


# 14. Create MYSQL Server in a private subnet
resource "aws_instance" "mysql_server" {
  ami           = var.mysql_server_ami
  instance_type = var.mysql_server_instance_type
  subnet_id     = aws_subnet.clxdev_subnet_pri.id
  # key_name = aws_key_pair.webserver_key.key_name
  vpc_security_group_ids = [aws_security_group.clxdev_sg_mysql.id]

  tags = {
    Name = var.mysql_server_tag
  }
}
