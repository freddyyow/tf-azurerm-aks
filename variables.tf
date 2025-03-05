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

variable "resource_group_name" {

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

}

variable "node_count" {

}

variable "min_count" {

}

variable "max_count" {

}

variable "vm_size" {

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
  type = map(any)

  # default = {
  #   auto_scaling_enabled = True
  #   node_count = <num>
  #   min_count = <num>
  #   max_count = <num>
  #   vm_size = <num>
  # }
}


