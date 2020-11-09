provider "azurerm" {
    version = "2.5.0"
    features {}
}

terraform {
    backend "azurerm" {
        resource_group_name  = "TF-BlobStorage-for-state"
        storage_account_name = "tfstatestorage0x"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

variable imagebuild {
  type        = string
  description = "Latest image build version"
}


resource "azurerm_resource_group" "tf_test" {
  name = "tfmainrg"
  location = "Australia East"
}


resource "azurerm_container_group" "tfcg_test" {
  name                      = "weatherapi"
  location                  = azurerm_resource_group.tf_test.location
  resource_group_name       = azurerm_resource_group.tf_test.name

  ip_address_type     = "public"
  dns_name_label      = "0xshyamweatherapi"
  os_type             = "Linux"

  container {
      name            = "weatherapi"
      image           = "0xshyam/weatherapi:${var.imagebuild}"
        cpu             = "1"
        memory          = "1"

        ports {
            port        = 80
            protocol    = "TCP"
        }
  }
}