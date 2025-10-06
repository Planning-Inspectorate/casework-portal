apps_config = {
  app_service_plan = {
    sku                      = "B1"
    per_site_scaling_enabled = false
    worker_count             = 1
    zone_balancing_enabled   = false
  }
  node_environment         = "production"
  private_endpoint_enabled = true

  auth = {
    client_id = "30a34d1a-473e-4a7f-ad6d-fa574c52a509"
  }

  logging = {
    level = "warn"
  }

  redis = {
    capacity = 0
    family   = "C"
    sku_name = "Basic"
  }
}

common_config = {
  resource_group_name = "pins-rg-common-dev-ukw-001"
  action_group_names = {
    iap      = "pins-ag-odt-iap-dev"
    its      = "pins-ag-odt-its-dev"
    info_sec = "pins-ag-odt-info-sec-dev"
  }
}

environment = "dev"

front_door_config = {
  name        = "pins-fd-common-tooling"
  rg          = "pins-rg-common-tooling"
  ep_name     = "pins-fde-scheduling"
  use_tooling = true
}

vnet_config = {
  address_space             = "10.23.0.0/22"
  apps_subnet_address_space = "10.23.0.0/24"
  main_subnet_address_space = "10.23.1.0/24"
}

waf_rate_limits = {
  enabled             = true
  duration_in_minutes = 5
  threshold           = 1500
}

web_domains = {
  portal = "manage-casework-dev.planninginspectorate.gov.uk"
}