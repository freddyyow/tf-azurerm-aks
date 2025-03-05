locals {
  common_tags = {
    DeployedWith = "Terraform",
    Owner        = "PlatformEngineering"
    Environment  = var.environment_map[var.target_environment]
  }
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                       = "${var.project_name}-${var.environment_map[var.target_environment]}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  dns_prefix_private_cluster = var.project_name
  private_cluster_enabled    = var.private_cluster_enabled
  automatic_upgrade_channel  = var.automatic_update_channel
  kubernetes_version         = var.kubernetes_version
  sku_tier                   = var.target_environment == "PROD" ? "Standard" : "Free"
  #automatic_upgrade_channel  = var.env == "prod" ? "stable" : "rapid"
  # sku_tier                   = var.env == "prod" ? "Standard" : "Free"
  #   auto_scaler_profile {

  #   }
  dynamic "default_node_pool" {
    for_each = var.default_node_pool_settings
    #iterator = "test"

    content {
      name                 = default_node_pool.key
      auto_scaling_enabled = var.default_node_pool_settings.auto_scaling_enabled
      # node_count           = var.node_count
      # min_count            = var.min_count
      # max_count            = var.max_count
      # vm_size              = var.vm_size
      node_count = default_node_pool.value.default_node_pool_settings.node_count
      min_count  = default_node_pool.value.min_count
      max_count  = default_node_pool.value.max_count
      vm_size    = default_node_pool.value.vm_size
      #vm_size              = var.env == "prod" ? var.default_pool_vm_size : "Standard_DS2_v2"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags, local.common_tags)

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count, kubernetes_version, tags]
  }
}