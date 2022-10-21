# NAT Gateway Variable
variable "nat_gw_tag" {
  description = "tag name for nat gateway"
  type        = string
  default     = "clxdev-nat-gateway-tag"
}