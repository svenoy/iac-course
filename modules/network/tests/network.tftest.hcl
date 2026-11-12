mock_provider "azurerm" {}

variables {
  student_id          = "ss963"
  project_name        = "iac"
  location            = "norwayeast"
  resource_group_name = "ss963-iac-dev-rg"
}

run "subnets_have_correct_cidr" {
  command = plan

  assert {
    condition     = azurerm_subnet.this.address_prefixes[0] == "10.0.1.0/24"
    error_message = "The main subnet must have CIDR 10.0.1.0/24."
  }

  assert {
    condition     = azurerm_subnet.data.address_prefixes[0] == "10.0.2.0/24"
    error_message = "The data subnet must have CIDR 10.0.2.0/24."
  }
}

run "names_use_prefix" {
  command = plan

  assert {
    condition     = azurerm_virtual_network.this.name == "ss963-iac-vnet"
    error_message = "The VNet name must be <student_id>-<project_name>-vnet."
  }
}

run "invalid_project_rejected" {
  command = plan

  variables {
    project_name = "Invalid Project Name"
  }

  expect_failures = [var.project_name]
}

# Added in part F of Module 9, to test that SSH is not open to the entire internet.
run "ssh_is_not_open_to_internet" {
  command = plan

  assert {
    condition = alltrue([
      for r in azurerm_network_security_group.this.security_rule :
      r.source_address_prefix != "*" if r.destination_port_range == "22"
    ])
    error_message = "SSH (port 22) must not be open to the entire internet."
  }
}