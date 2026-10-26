variable "project_name" {
  description = "Name of the project, used for tagging and naming resources"
  type        = string
  default     = "buycontroll"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/25"
}
