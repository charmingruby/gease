module "container" {
  source                  = "./modules/container"
  tags                    = local.tags
  github_repository       = var.github_repository
  github_repository_owner = var.github_repository_owner
  oidc_thumbprint         = var.oidc_thumbprint
}
