output "vmname" {
  value = "${azurerm_virtual_machine.demo.name}"
}

output "vmip" {
  value = "${azurerm_public_ip.demo.ip_address}"
}
