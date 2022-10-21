variable "bastion_ami" {
  description = "ami for bastion host"
  type        = string
  default     = "ami-09d3b3274b6c5d4aa"
}

variable "bastion_instance_type" {
  description = "instance type for bastion host"
  type        = string
  default     = "t2.micro"
}

variable "bastion_instance_tag" {
  description = "tag name for bastion host"
  type        = string
  default     = "clxdev-bastion-host"
}

# ec2 instance variables -- wordpress host
variable "wp_ami" {
  description = "ami for wordpress host"
  type        = string
  default     = "ami-09d3b3274b6c5d4aa"
}

variable "wp_instance_type" {
  description = "instance type for wordpress host"
  type        = string
  default     = "t2.micro"
}

variable "wp_instance_tag" {
  description = "tag name for wordpress host"
  type        = string
  default     = "clxdev-wordpress-host"
}

variable "mysql_server_ami" {
  description = "ami for mysql server"
  type        = string
  default     = "ami-09d3b3274b6c5d4aa"
}

variable "mysql_server_instance_type" {
  description = "instance type for mysql server"
  type        = string
  default     = "t2.micro"
}

variable "mysql_server_tag" {
  description = "tag name for mysql server"
  type        = string
  default     = "clxdev-mysql-server-tag"
}