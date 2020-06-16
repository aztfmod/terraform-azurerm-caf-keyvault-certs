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
    common_name = "contoso.com"
    email       = "joe@contoso.com"
    private_key = {
      algorithm = "RSA"
    }
  }

}