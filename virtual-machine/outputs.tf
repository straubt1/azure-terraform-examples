output "vmname" {
  value = "${azurerm_virtual_machine.vminstance.name}"
}
output "vmip" {
  value = "${azurerm_virtual_machine.vminstance.ip}"
}