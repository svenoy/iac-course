terraform {
  required_version = ">= 1.16.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.4"
    }
  }
}
# De faste verdiene ligger i backend.hcl – filen som blir bootstrap-stacken's output.
# -backend-config kan brukes både med path (-backend-config=backend.hcl) 
# og med et enkelt nøkkel=verdi-par (-backend-config="key=dev/network.tfstate").


provider "azurerm" {
  features {}

  # azurerm 5.x registrerer ingen resource providers automatisk.
  resource_providers_to_register = ["Microsoft.Storage", "Microsoft.KeyVault"]
}