variable "project_name" {
  description = "Name of the project, used for tagging and naming resources"
  type        = string
  default     = "buycontroll"
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "prod"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  type = map(string)
  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

variable "function_name" {
  description = "Nome da funcao Lambda"
  type        = string
  default     = "buycontroll-price-ingest"
}
