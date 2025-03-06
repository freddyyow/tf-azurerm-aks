resource "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 1 : 0

  location = var.location
  name = var.name
}


module "aks_cluster" {
    source = "../../tf-azurerm-aks"
    default_node_pool_settings =
    tags = 
    kubernetes_version =
    vnet_subnet_id = 
    location = 
    project_name = 
    linux_os_config =
    sysctl_config =
    resource_group_name = 
    target_environment = 
}