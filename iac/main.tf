module "pipeline" {
  source                  = "./modules/pipeline"
  github_repository       = var.github_repository
  github_repository_owner = var.github_repository_owner
  tags                    = local.tags
}

module "network" {
  source     = "./modules/network"
  tags       = local.tags
  aws_region = var.aws_region
}

module "container" {
  source                  = "./modules/container"
  tags                    = local.tags
  github_repository       = var.github_repository
  github_repository_owner = var.github_repository_owner
  oidc_thumbprint         = var.oidc_thumbprint
  subnet_ids              = module.network.subnets_ids
  vpc_id                  = module.network.vpc_id
}
