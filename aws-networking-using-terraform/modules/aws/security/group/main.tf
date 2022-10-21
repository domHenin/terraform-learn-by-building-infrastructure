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