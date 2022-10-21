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