locals {
  common_tags = {
    DeployedWith = "Terraform",
    Owner        = "PlatformEngineering"
    Environment  = var.environment_map[var.target_environment]
  }
}