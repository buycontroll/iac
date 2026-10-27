variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "project_name" {
  description = "Name of the project, used for tagging and naming resources"
  type        = string
}

variable "private_subnets" {
  description = "Map of availability zones to CIDR blocks for private subnets"
  type = map(string)
}
