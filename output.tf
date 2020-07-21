

# {for x in range(0,9) : x => x}
output "secret_id" {
  value = azurerm_key_vault_certificate.certificates.secret_id
}

