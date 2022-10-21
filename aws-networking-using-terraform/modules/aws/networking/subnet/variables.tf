# private subnet variables
variable "cidr_priv_subnet" {
  description = "cidr block range for private subnet"
  type        = string
  default     = "192.168.1.0/24"
}

variable "subnet_priv_tag" {
  description = "tag name for private subnet"
  type        = string
  default     = "clxdev-private-subnet-tag"
}

# public subnet variables
variable "cidr_pub_subnet" {
  description = "cidr block range for public subnet"
  type        = string
  default     = "192.168.0.0/24"
}

variable "subnet_pub_tag" {
  description = "tag name for public subnet"
  type        = string
  default     = "clxdev-public-subnet-tag"
}