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
  resource_group_name = "pins-rg-common-prod-ukw-001"
  action_group_names = {
    iap      = "pins-ag-odt-iap-prod"
    its      = "pins-ag-odt-its-prod"
    info_sec = "pins-ag-odt-info-sec-prod"
  }
}

environment = "prod"

front_door_config = {
  name        = "pins-fd-common-prod"
  rg          = "pins-rg-common-prod"
  ep_name     = "pins-fde-scheduling-prod"
  use_tooling = false
}

vnet_config = {
  address_space             = "10.23.12.0/22"
  apps_subnet_address_space = "10.23.12.0/24"
  main_subnet_address_space = "10.23.13.0/24"
}

waf_rate_limits = {
  enabled             = true
  duration_in_minutes = 5
  threshold           = 1500
}

web_domains = {
  portal = "manage-casework.planninginspectorate.gov.uk"
}