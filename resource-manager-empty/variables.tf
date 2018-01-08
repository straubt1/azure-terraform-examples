# variable "subscription_id" {
#   description = "The Azure Subscription Id - found in the azure portal"
# }

# variable "client_id" {
#   description = "The Client Id assigned when adding the application to the authorizing Azure Active Directory Account"
# }

# variable "client_secret" {
#   description = "The Client Secret assigned in Azure Active Directory when adding a key"
# }

# variable "tenant_id" {
#   description = "The Guid assigned to the application in Azure Active Directory"
# }

variable "region" {
  description = ""
  default     = "eastus"
}
