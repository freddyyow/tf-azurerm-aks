variable "project_name" {
  type        = string
  description = "The business unit the cluster belongs to - CCMS, LS, etc."
}

variable "location" {
  type        = string
  description = "The Azure region to deploy to"
  # default     = "Canada Central"

  validation {
    condition     = contains(["Canada Central", "Canada East"], var.location)
    error_message = "location variable must be set to one of ['Canada Central', 'Canada East']"
  }
}

variable "create_resource_group" {
  type     = bool
  nullable = false

  default = true
}

variable "resource_group_name" {
  type = string
}

variable "private_cluster_enabled" {
  type        = string
  description = "Should be be a private only cluster"

  default = true
}

variable "automatic_update_channel" {
  type    = string
  default = "none"
}

variable "kubernetes_version" {
  type = string
}

variable "tags" {

}

variable "target_environment" {
  type = string

  validation {
    condition     = contains(["DEV", "UAT", "STAGE", "QA", "PROD"], var.target_environment)
    error_message = "Must be set as one of the following options ['DEV', 'UAT', 'STAGE', 'QA', 'PROD']"
  }
}

variable "environment_map" {
  type        = map(string)
  description = "map of environments mapping to possible target environments"

  default = {
    "DEV"   = "dev",
    "UAT"   = "uat",
    "STAGE" = "staging"
    "QA"    = "qa"
    "PROD"  = "prod"
  }
}

variable "default_node_pool_settings" {
  type = map(object({
    auto_scaling_enabled = optional(bool, true)
    node_count           = number
    min_count            = number
    max_count            = number
    node_labels          = optional(map(string))
    os_sku               = optional(string, "Ubuntu")
    vm_size              = string
    #default = {}
  }))
}

variable "linux_os_config" {
  type = list(object({
    swap_file_size_mb = optional(number)
  }))
}

variable "node_pool_settings" {
  type = map(object({
    node_count           = number
    min_count            = number
    max_count            = number
    vm_size              = string
    auto_scaling_enabled = optional(bool, true)
    os_type              = optional(string, "Linux")
    priority             = optional(string, "Regular")
    os_sku               = optional(string, "Ubuntu")
    node_taints          = optional(list(string))
  }))
  default     = {}
  description = "value"
}

variable "sysctl_config" {
  type = list(object({
    vm_max_map_count = optional(number)
    vm_swappiness    = optional(number)
  }))
}

variable "vnet_subnet_id" {

}