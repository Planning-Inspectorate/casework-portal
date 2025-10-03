locals {
  org              = "pins"
  service_name     = "casework-portal"
  primary_location = "uk-south"

  resource_suffix = "${local.service_name}-${var.environment}"

  tags = {
    CreatedBy   = "terraform"
    Environment = var.environment
    ServiceName = local.service_name
    location    = local.primary_location
  }
}
