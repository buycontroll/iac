variable "function_name" {
  description = "Nome da funcao Lambda"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "environment_variables" {
  description = "Variaveis de ambiente para a Lambda"
  type        = map(string)
  default     = {}
}
