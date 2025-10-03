# variables should be sorted A-Z

variable "apps_config" {
  description = "Config for the apps"
  type = object({
    app_service_plan = object({
      sku                      = string
      per_site_scaling_enabled = bool
      worker_count             = number
      zone_balancing_enabled   = bool
    })
    node_environment = string

    auth = object({
      client_id = string
    })

    logging = object({
      level = string
    })

    redis = object({
      capacity = number
      family   = string
      sku_name = string
    })
  })
}

variable "environment" {
  description = "The name of the environment in which resources will be deployed"
  type        = string
}

variable "front_door_config" {
  description = "Config for the frontdoor in tooling subscription"
  type = object({
    name        = string
    rg          = string
    ep_name     = string
    use_tooling = bool
  })
}

variable "tooling_config" {
  description = "Config for the tooling subscription resources"
  type = object({
    container_registry_name = string
    container_registry_rg   = string
    network_name            = string
    network_rg              = string
    subscription_id         = string
  })
}

variable "vnet_config" {
  description = "VNet configuration"
  type = object({
    address_space             = string
    apps_subnet_address_space = string
    main_subnet_address_space = string
  })
}

variable "waf_rate_limits" {
  description = "waf rule configuration for rate limiting"
  type = object({
    enabled             = bool
    duration_in_minutes = number
    threshold           = number
  })
}

variable "web_domains" {
  description = "app domains"
  type = object({
    portal = string
  })
}