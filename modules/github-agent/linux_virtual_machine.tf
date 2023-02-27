# locals {
#   update_time            = "06:00"
#   update_date            = substr(time_offset.this.rfc3339, 0, 10)
#   update_timezone        = "UTC"
#   update_max_hours       = "4"
#   update_classifications = "Critical, Security, Other"
#   update_reboot_settings = "IfRequired"
#   update_day             = "Thursday"
#   update_occurrence      = "2"
# }

# # https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/offset
# resource "time_offset" "this" {
#   offset_days = 1
# }

# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
# resource "azurerm_public_ip" "this" {
#   name                = "${var.project.customer}${var.project.name}${var.project.environment}lvm-pip"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.this.name

#   allocation_method = "Dynamic"
#   domain_name_label = "${var.project.customer}${var.project.name}${var.project.environment}lvm"
# }

# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
# resource "azurerm_network_interface" "this" {
#   name                = "${var.project.customer}${var.project.name}${var.project.environment}lvm-nic"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.this.name

#   ip_configuration {
#     name                          = "IpConfig"
#     subnet_id                     = azurerm_subnet.this.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.this.id
#   }
# }

# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
# resource "azurerm_linux_virtual_machine" "this" {
#   name                = "${var.project.customer}${var.project.name}${var.project.environment}lvm"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.this.name

#   admin_username = var.admin_username

#   admin_ssh_key {
#     username   = var.admin_username
#     public_key = file(".ssh/id_rsa.pub")
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   network_interface_ids = [
#     azurerm_network_interface.this.id
#   ]

#   os_disk {
#     name                 = "${var.project.customer}${var.project.name}${var.project.environment}lvm-osdisk"
#     caching              = "ReadWrite"
#     storage_account_type = "StandardSSD_LRS"
#   }

#   size = var.linux_virtual_machine.size

#   source_image_reference {
#     publisher = var.linux_virtual_machine.source_image_reference.publisher
#     offer     = var.linux_virtual_machine.source_image_reference.offer
#     sku       = var.linux_virtual_machine.source_image_reference.sku
#     version   = var.linux_virtual_machine.source_image_reference.version
#   }
# }

# # https://learn.microsoft.com/en-us/cli/azure/vm/run-command?view=azure-cli-latest#az-vm-run-command-invoke
# # https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
# resource "null_resource" "vmss" {
#   provisioner "local-exec" {
#     command = "az vm run-command invoke --command-id RunShellScript --name ${azurerm_linux_virtual_machine.this.name} --resource-group ${azurerm_resource_group.this.name} --scripts 'sudo apt update && sudo apt upgrade -y && sudo apt install unzip -y'"
#   }
# }

# # Shutdown virtual machine automatically
# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dev_test_global_vm_shutdown_schedule
# resource "azurerm_dev_test_global_vm_shutdown_schedule" "this" {
#   virtual_machine_id = azurerm_linux_virtual_machine.this.id
#   location           = var.location

#   enabled = true

#   daily_recurrence_time = "1700"
#   timezone              = "UTC"

#   notification_settings {
#     enabled = false
#   }
# }
