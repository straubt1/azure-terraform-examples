provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
}

resource "azurerm_resource_group" "vminstance" {
    name = "terraformvminstance"
    location = "${var.region}"
}

resource "azurerm_virtual_network" "vminstance" {
    name = "acctvn"
    address_space = ["10.0.0.0/16"]
    location = "West US"
    resource_group_name = "${azurerm_resource_group.vminstance.name}"
}

resource "azurerm_subnet" "vminstance" {
    name = "acctsub"
    resource_group_name = "${azurerm_resource_group.vminstance.name}"
    virtual_network_name = "${azurerm_virtual_network.vminstance.name}"
    address_prefix = "10.0.2.0/24"
}

resource "azurerm_network_interface" "vminstance" {
    name = "acctni"
    location = "West US"
    resource_group_name = "${azurerm_resource_group.vminstance.name}"

    ip_configuration {
        name = "testconfiguration1"
        subnet_id = "${azurerm_subnet.vminstance.id}"
        private_ip_address_allocation = "dynamic"
    }
}

resource "azurerm_storage_account" "vminstance" {
    name = "${var.storagename}"
    resource_group_name = "${azurerm_resource_group.vminstance.name}"
    location = "westus"
    account_type = "Standard_LRS"

    tags {
        environment = "staging"
    }
}

resource "azurerm_storage_container" "vminstance" {
    name = "vhds"
    resource_group_name = "${azurerm_resource_group.vminstance.name}"
    storage_account_name = "${azurerm_storage_account.vminstance.name}"
    container_access_type = "private"
}

resource "azurerm_virtual_machine" "vminstance" {
    name = "acctvm"
    location = "West US"
    resource_group_name = "${azurerm_resource_group.vminstance.name}"
    network_interface_ids = ["${azurerm_network_interface.vminstance.id}"]
    vm_size = "Standard_A0"

    storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "14.04.2-LTS"
        version = "latest"
    }

    storage_os_disk {
        name = "myosdisk1"
        vhd_uri = "${azurerm_storage_account.vminstance.primary_blob_endpoint}${azurerm_storage_container.vminstance.name}/myosdisk1.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "${var.computername}"
        admin_username = "${var.username}"
        admin_password = "${var.password}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
        environment = "staging"
    }
}