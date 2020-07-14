locals {
  convention       = "cafrandom"
  name             = "caftest-vnet"
  name_la          = "aztfmodcaftestlavalid"
  name_diags       = "caftestdiags"
  location         = "southeastasia"
  prefix           = ""
  max_length       = ""
  postfix          = ""
  enable_event_hub = false

  resource_groups = {
    test = {
      name     = "test-caf-domaincert"
      location = "southeastasia"
    },
  }
  tags = {
    environment = "DEV"
    owner       = "CAF"
  }

  ttl         = 10
  lock_zone   = false
  lock_domain = false

  domain = "domaintest123456.com"

  # changes to below will not update Domain, destroy first and reapply
  contract = {
    name_first   = "John"
    name_last    = "Doe"
    email        = "test@contoso.com"
    phone        = "+65.12345678"
    organization = "Sandpit"
    job_title    = "Engineer"
    address1     = "Singapore"
    address2     = ""
    postal_code  = "018898"
    state        = "Singapore"
    city         = "Singapore"
    country      = "SG"
    auto_renew   = true
  }




  solution_plan_map = {
    NetworkMonitoring = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/NetworkMonitoring"
    },
  }

  akv_config = {
    name = "test-caf-akv"

    akv_features = {
      enabled_for_disk_encryption     = false
      enabled_for_deployment          = false
      enabled_for_template_deployment = false
      soft_delete_enabled             = true
      purge_protection_enabled        = true
    }
    sku_name = "premium"
    # network_acls = {
    #     bypass = "AzureServices"
    #     default_action = "Deny"
    # }

    diagnostics_settings = {
      log = [
        # ["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period] 
        ["AuditEvent", true, true, 60],
      ]
      metric = [
        #["Category name",  "Diagnostics Enabled(true/false)", "Retention Enabled(true/false)", Retention_period]                 
        ["AllMetrics", true, true, 60],
      ]
    }
  }

  certificate = {
    common_name = local.domain
    email       = "joe@contoso.com"
    private_key = {
      algorithm = "RSA"
    }
  }

}