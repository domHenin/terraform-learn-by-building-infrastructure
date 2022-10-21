# 4. Create Route Table -- public
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

