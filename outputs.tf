output "kubernetes_cluster_id" {
  value = azurerm_kubernetes_cluster.kubernetes_cluster[*].id
}

output "kubernetes_node_pool_id" {
  value = azurerm_kubernetes_cluster_node_pool.pool[*].id
}