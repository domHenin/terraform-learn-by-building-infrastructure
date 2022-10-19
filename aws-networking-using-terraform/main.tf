# 1. Create Provider
provider "aws" {
  region = var.aws_region
}

# 2a. Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_tag
  }
}

# 2b. Create Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id

  cidr_block        = var.priv_cidr
  availability_zone = "us-east-1b"

  tags = {
    "Name" = var.priv_subnet_tag
  }
}

# 2b. Create Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id

  cidr_block              = var.publ_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = var.publ_subnet_tag
  }
}

# 3. Create Internet Gateway for outside connection with VPC
resource "aws_internet_gateway" "facing_gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = var.igw_tag
  }
}

resource "aws_internet_gateway_attachment" "facing_attach_gw" {
  vpc_id              = aws_vpc.vpc.id
  internet_gateway_id = aws_internet_gateway.facing_gw.id
}


# 4. Create Route Table
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.rt_public_cidr
    gateway_id = aws_internet_gateway.facing_gw.id
  }

  tags = {
    "Name" = var.rt_tag
  }
}

# 5. Associate Route table with Public Subnet
resource "aws_route_table_association" "rt_associate" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt_public.id
}

# 6. Create NAT Gateway
# 6a. Create EIP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}
# 6b. NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = var.nat_gw_tag
  }

  depends_on = [aws_internet_gateway.facing_gw]
}


# 7. Create Route Table for private subnet and NAT gateway
resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.rt_private_cidr
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    "Name" = var.rt_private_tag
  }
}

# 8. Associate Route Table to the private subnet.
resource "aws_route_table_association" "nat_private_associate" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.rt_private.id
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
resource "aws_security_group" "bastion_ssh" {
  name        = var.bastion_sg_name
  description = "Allow SSH"
  vpc_id      = aws_vpc.vpc.id

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
resource "aws_instance" "bastion_host" {
  ami                         = var.bastion_ami
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.bastion_ssh.id]
  associate_public_ip_address = "true"

  tags = {
    Name = var.bastion_instance_tag
  }
}

# 11. Create a Security group which allow HTTP and SSH for Bastion Host
resource "aws_security_group" "wp_http" {
  name        = var.wp_sg_name
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

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
    security_groups = [aws_security_group.bastion_ssh.id]
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
resource "aws_instance" "wordpress" {
  ami                         = var.wp_ami
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  # key_name                    = aws_key_pair.webserver_key.key_name
  vpc_security_group_ids      = [aws_security_group.wp_http.id]
  associate_public_ip_address = "true"

  tags = {
    Name = var.wp_instance_tag
  }
}

# 13. Create a Security Group for MySQL and SSH for Bastion Host
resource "aws_security_group" "sg_mysql" {
  name        = var.mysql_sg_name
  description = "Allow mysql inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "mysql"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wp_http.id]
  }

  ingress {
    description     = "ssh"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_ssh.id]
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

  depends_on = [aws_security_group.wp_http, aws_security_group.bastion_ssh]
}


# 14. Create MYSQL Server in a private subnet
resource "aws_instance" "mysql_server" {
  ami           = var.mysql_server_ami
  instance_type = var.mysql_server_instance_type
  subnet_id     = aws_subnet.private_subnet.id
  # key_name = aws_key_pair.webserver_key.key_name
  vpc_security_group_ids = [aws_security_group.sg_mysql.id]

  tags = {
    Name = var.mysql_server_tag
  }
}
