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