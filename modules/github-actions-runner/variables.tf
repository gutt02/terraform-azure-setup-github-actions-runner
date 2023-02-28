locals {
  # detect OS
  # Directories start with "C:..." on Windows; All other OSs use "/" for root.
  is_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true

  gh_runner_vm   = "VirtualMachine"
  gh_runner_vmss = "VirtualMachineScaleSet"
}

variable "admin_username" {
  type        = string
  sensitive   = true
  description = "Linux Virtual Machine Admin User."
}

# VirtualMachine or VirtualMachineScaleSet
variable "gh_runner_type" {
  type        = string
  default     = "VirtualMachine"
  description = "Type of the GitHub Runner."
}

# curl ipinfo.io/ip
variable "client_ip" {
  type = object({
    name             = string
    cidr             = string
    start_ip_address = string
    end_ip_address   = string
  })

  default = {
    name             = "ClientIP01"
    cidr             = "94.134.104.180/32"
    start_ip_address = "94.134.104.180"
    end_ip_address   = "94.134.104.180"
  }

  description = "List of client ips, can be empty."
}

variable "client_secret" {
  type        = string
  sensitive   = true
  description = "Client secret of the service principal."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Default Azure region, use Azure CLI notation."
}

variable "project" {
  type = object({
    customer    = string
    name        = string
    environment = string
  })

  default = {
    customer    = "azc"
    name        = "base"
    environment = "vse"
  }

  description = "Project details, like customer name, environment, etc."
}

variable "linux_virtual_machine" {
  type = object({
    size = string

    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
  })

  default = {
    size = "Standard_A1_v2"
    # size = "Standard_A2_v2"

    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
  }

  description = "Linux Virtual Machine."
}

variable "tags" {
  type = object({
    created_by  = string
    contact     = string
    customer    = string
    environment = string
    project     = string
  })

  default = {
    created_by  = "vsp-base-msdn-sp-tf"
    contact     = "contact@me"
    customer    = "Azure Cloud"
    environment = "Visual Studio Enterprise"
    project     = "GitHub Agent"
  }

  description = "Default tags for resources, only applied to resource groups"
}

variable "virtual_network" {
  type = object({
    address_space = string

    subnets = map(object({
      name          = string
      address_space = string
    }))
  })

  default = {
    address_space = "192.168.0.0/28"

    subnets = {
      virtual_machine = {
        name          = "virtual-machine"
        address_space = "192.168.0.0/28"
      }
    }
  }

  description = "VNET destails."
}
