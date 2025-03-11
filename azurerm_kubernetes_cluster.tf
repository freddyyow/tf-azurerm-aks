resource "azurerm_resource_group" "resource_group" {
  count = var.create_resource_group ? 1 : 0


  name = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  for_each                   = var.default_node_pool_settings
  name                       = "${var.project_name}-${var.environment_map[var.target_environment]}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  dns_prefix_private_cluster = var.project_name
  private_cluster_enabled    = var.private_cluster_enabled
  automatic_upgrade_channel  = var.automatic_update_channel
  kubernetes_version         = var.kubernetes_version
  sku_tier                   = var.environment_map[var.target_environment] == "prod" ? "Standard" : "Free"

  default_node_pool {
    name                 = "default-node-pool"
    auto_scaling_enabled = each.value.auto_scaling_enabled
    node_count           = each.value
    min_count            = each.value.min_count
    max_count            = each.value.max_count
    vm_size              = each.value.vm_size
    node_labels          = each.value.node_labels
    os_sku               = each.value.os_sku
  }
  # dynamic "default_node_pool" {
  #   for_each = var.default_node_pool_settings
  #   #iterator = "test"

  #   content {
  #     name                 = default_node_pool.key
  #     auto_scaling_enabled = var.default_node_pool_settings.auto_scaling_enabled
  #     node_count = default_node_pool.value.default_node_pool_settings.node_count
  #     min_count  = default_node_pool.value.min_count
  #     max_count  = default_node_pool.value.max_count
  #     vm_size    = default_node_pool.value.vm_size

  #   }
  # }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags, local.common_tags)

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count, kubernetes_version, tags]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pool" {
  for_each = var.node_pool_settings

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster[*].id
  vm_size               = each.value.vm_size
  auto_scaling_enabled  = each.value.auto_scaling_enabled
  node_count            = each.value.node_count
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  priority              = each.value.priority
  vnet_subnet_id        = var.vnet_subnet_id
  os_type               = each.value.os_type
  os_sku                = each.value.os_sku
  node_taints           = each.value.node_taints

  dynamic "linux_os_config" {
    for_each = var.linux_os_config

    content {
      swap_file_size_mb = linux_os_config.value.swap_file_size_mb


      dynamic "sysctl_config" {
        for_each = var.sysctl_config

        content {
          vm_max_map_count = sysctl_config.value.vm_max_map_count
          vm_swappiness    = sysctl_config.value.vm_swappiness
        }
      }
    }
  }
  tags = merge(var.tags, local.common_tags)
}

