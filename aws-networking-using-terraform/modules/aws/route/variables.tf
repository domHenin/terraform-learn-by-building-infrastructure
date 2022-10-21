# route table variables -- public
variable "cidr_pub_rt" {
  description = "cidr block range for public route table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "pub_rt_tag" {
  description = "tag name for public route table"
  type        = string
  default     = "clxdev-public-route-table-tag"
}

# route table variables -- private
variable "cidr_priv_rt" {
  description = "cidr block range for private route table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "priv_rt_tag" {
  description = "tag name for private route table"
  type        = string
  default     = "clxdev-private-route-table-tag"
}