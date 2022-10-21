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