provider "azurerm" {
  # subscription_id = "${var.subscription_id}"
  # client_id       = "${var.client_id}"
  # client_secret   = "${var.client_secret}"
  # tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "demo" {
  name     = "terraformvminstance"
  location = "${var.region}"
}

resource "azurerm_virtual_network" "demo" {
  name                = "acctvn"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.demo.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
}

resource "azurerm_subnet" "demo" {
  name                 = "acctsub"
  resource_group_name  = "${azurerm_resource_group.demo.name}"
  virtual_network_name = "${azurerm_virtual_network.demo.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "demo" {
  name                         = "tom-pip"
  location                     = "${azurerm_resource_group.demo.location}"
  resource_group_name          = "${azurerm_resource_group.demo.name}"
  public_ip_address_allocation = "Dynamic"
  idle_timeout_in_minutes      = 30

  tags {
    environment = "test"
  }
}

resource "azurerm_network_interface" "demo" {
  name                = "acctni"
  location            = "${azurerm_resource_group.demo.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.demo.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.demo.id}"
  }
}

resource "azurerm_managed_disk" "demo" {
  name                 = "datadisk_existing"
  location             = "${azurerm_resource_group.demo.location}"
  resource_group_name  = "${azurerm_resource_group.demo.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

resource "azurerm_virtual_machine" "demo" {
  name                             = "acctvm"
  location                         = "${azurerm_resource_group.demo.location}"
  resource_group_name              = "${azurerm_resource_group.demo.name}"
  network_interface_ids            = ["${azurerm_network_interface.demo.id}"]
  vm_size                          = "Standard_DS1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "datadisk_new"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.demo.name}"
    managed_disk_id = "${azurerm_managed_disk.demo.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.demo.disk_size_gb}"
  }

  os_profile {
    computer_name  = "hostname"
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
