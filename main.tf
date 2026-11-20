module "network" {
  source          = "./modules/network"
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  private_subnets = var.private_subnets
}

module "api_gateway" {
  source       = "./modules/api-gateway-rest"
  project_name = var.project_name
  environment  = var.environment
}
