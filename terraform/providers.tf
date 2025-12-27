terraform {
  cloud {

    organization = "arielai91"

    workspaces {
      name = "Wasigo"
    }
  }
}

provider "azurerm" {
  features {}
}

