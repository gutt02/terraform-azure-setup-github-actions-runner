# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
resource "azurerm_public_ip" "this" {
  count = var.gh_actions_runner_type == local.gh_actions_runner_vm ? 1 : 0

  name                = "${var.project.customer}${var.project.name}${var.project.environment}ghar-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  allocation_method = "Dynamic"
  domain_name_label = "${var.project.customer}${var.project.name}${var.project.environment}ghar"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
resource "azurerm_network_interface" "this" {
  count = var.gh_actions_runner_type == local.gh_actions_runner_vm ? 1 : 0

  name                = "${var.project.customer}${var.project.name}${var.project.environment}ghar-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "IpConfig"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this[0].id
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
resource "azurerm_linux_virtual_machine" "this" {
  count = var.gh_actions_runner_type == local.gh_actions_runner_vm ? 1 : 0

  name                = "${var.project.customer}${var.project.name}${var.project.environment}ghar"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(".ssh/id_rsa.pub")
  }

  identity {
    type = "SystemAssigned"
  }

  network_interface_ids = [
    azurerm_network_interface.this[0].id
  ]

  os_disk {
    name                 = "${var.project.customer}${var.project.name}${var.project.environment}ghar-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  size = var.linux_virtual_machine.size

  source_image_reference {
    publisher = var.linux_virtual_machine.source_image_reference.publisher
    offer     = var.linux_virtual_machine.source_image_reference.offer
    sku       = var.linux_virtual_machine.source_image_reference.sku
    version   = var.linux_virtual_machine.source_image_reference.version
  }
}

# https://learn.microsoft.com/en-us/cli/azure/vm/run-command?view=azure-cli-latest#az-vm-run-command-invoke
# https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
resource "null_resource" "vm" {
  count = var.gh_actions_runner_type == local.gh_actions_runner_vm ? 1 : 0

  provisioner "local-exec" {
    command = "az vm run-command invoke --command-id RunShellScript --name ${azurerm_linux_virtual_machine.this[0].name} --resource-group ${azurerm_resource_group.this.name} --scripts @scripts/post_deployment.sh"
  }

  depends_on = [
    azurerm_linux_virtual_machine.this[0]
  ]
}

# Shutdown virtual machine automatically
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dev_test_global_vm_shutdown_schedule
resource "azurerm_dev_test_global_vm_shutdown_schedule" "this" {
  count = var.gh_actions_runner_type == local.gh_actions_runner_vm ? 1 : 0

  virtual_machine_id = azurerm_linux_virtual_machine.this[0].id
  location           = var.location

  enabled = true

  daily_recurrence_time = "1700"
  timezone              = "UTC"

  notification_settings {
    enabled = false
  }
}
