# issue with destroy & recreate https://github.com/terraform-providers/terraform-provider-acme/issues/68#issuecomment-508735169
# https://community.letsencrypt.org/t/unable-to-regenerate-certificate-with-terraform/80275/2
# ACME Let's Encrypt only works on public domain

# https://www.terraform.io/docs/providers/tls/r/private_key.html
resource "tls_private_key" "private_key" {
  algorithm = var.certificate.private_key.algorithm
  rsa_bits = lookup(var.certificate.private_key, "rsa_bits", null)
  ecdsa_curve = lookup(var.certificate.private_key, "ecdsa_curve", null)
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.certificate.email
}

resource "random_password" "password" {
  special = true
  length = 16
}

resource "acme_certificate" "certificate" {
  account_key_pem          = acme_registration.reg.account_key_pem
  common_name              = var.certificate.common_name
  certificate_p12_password = random_password.password.result

  dns_challenge {
    provider = "azure"
    config = {
      AZURE_RESOURCE_GROUP = var.domain_resource_group_name
    }
  }
}

# todo: implement details as per: https://www.terraform.io/docs/providers/azurerm/r/key_vault_certificate.html
resource "azurerm_key_vault_certificate" "certificates" {

  name         = trim(replace(replace(var.certificate.common_name, ".", "-"), "*", ""),"-")
  key_vault_id = var.keyvault_id

  certificate {
    contents = acme_certificate.certificate.certificate_p12
    password = random_password.password.result
  }

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      exportable = true
      key_size   = lookup(var.certificate.private_key, "rsa_bits", 2048)
      key_type   = var.certificate.private_key.algorithm
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }

  # provisioner "local-exec" {
  #   when    = "destroy"
  #   command = "az keyvault certificate purge --vault-name ${azurerm_key_vault.akv.name} --name ${self.name}"
  # }
}