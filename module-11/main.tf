terraform {
  required_version = ">= 1.16.0"
}

# Reads state only (never writes). Uses the same backend as Module 6/8 and the producer's key.
data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-demo-backend-ss963"
    storage_account_name = "stdemoss963"
    container_name       = "tfstate"
    key                  = "module-08/dev/network.tfstate"
    use_azuread_auth     = true
  }
}

output "fetched_subnet" {
  value = data.terraform_remote_state.network.outputs.subnet_id
}
