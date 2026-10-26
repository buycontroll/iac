terraform {
  cloud {
    organization = "buycontroll"
    workspaces {
      name = "iac"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
