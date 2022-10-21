variable "bastion_sg_name" {
  description = "name of bastion"
  type        = string
  default     = "bastion_ssh"
}

variable "bastion_sg_tag" {
  description = "tag name for bastion security group rule"
  type        = string
  default     = "clxdev-bastion-ssh-tag"
}

# security group variables -- wordpress http
variable "wp_sg_name" {
  description = "name for wordpress security group"
  type        = string
  default     = "wp_http"
}

variable "wp_http_sg_tag" {
  description = "tag name for wordpress security group"
  type        = string
  default     = "clxdev-wp-http-tag"
}

# security group -- mysql
variable "mysql_sg_name" {
  description = "name for mysql security group"
  type        = string
  default     = "sg_mysql"
}

variable "mysql_sg_tag" {
  description = "tag name for mysql security group"
  type        = string
  default     = "clxdev-mysql-tag"
}