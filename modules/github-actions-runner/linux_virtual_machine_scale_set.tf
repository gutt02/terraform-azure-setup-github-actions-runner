# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set
resource "azurerm_linux_virtual_machine_scale_set" "this" {
  count = var.gh_runner_type == local.gh_runner_vmss ? 1 : 0

  name                = "${var.project.customer}${var.project.name}${var.project.environment}gharss"
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

  instances = 1


  network_interface {
    name    = "${var.project.customer}${var.project.name}${var.project.environment}gharss-nic"
    primary = true

    ip_configuration {
      name      = "IpConfig"
      primary   = true
      subnet_id = azurerm_subnet.this.id
      public_ip_address {
        name              = "${var.project.customer}${var.project.name}${var.project.environment}gharss-pip"
        domain_name_label = "${var.project.customer}${var.project.name}${var.project.environment}gharss"
      }
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  sku = var.linux_virtual_machine.size

  source_image_reference {
    publisher = var.linux_virtual_machine.source_image_reference.publisher
    offer     = var.linux_virtual_machine.source_image_reference.offer
    sku       = var.linux_virtual_machine.source_image_reference.sku
    version   = var.linux_virtual_machine.source_image_reference.version
  }
}

# https://learn.microsoft.com/en-us/cli/azure/vm/run-command?view=azure-cli-latest#az-vm-run-command-invoke
# https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
resource "null_resource" "vmss" {
  count = var.gh_runner_type == local.gh_runner_vmss ? 1 : 0

  provisioner "local-exec" {
    command = "az vmss run-command invoke --command-id RunShellScript --name ${azurerm_linux_virtual_machine_scale_set.this[0].name} --resource-group ${azurerm_resource_group.this.name} --instance-id 0 --scripts @scripts/post_deployment.sh"
  }

  depends_on = [
    azurerm_linux_virtual_machine_scale_set.this[0]
  ]
}
