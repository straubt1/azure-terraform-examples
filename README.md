## Terraform Demo - Azure
https://www.terraform.io

```
terraform version

terraform init
```

## Set Credentials
Two Options:
 - Using the Azure CLI
 - Using Service Principal Credentials directly

`terrraform.tfvars`
```
subscription_id = ""
tenant_id       = ""
client_id       = ""
client_secret   = ""
```

## Planning and Building Infrastructure

```
terraform plan

terraform apply

terraform destroy
```


















## Local Docker Image
_build_
`docker build -t terraformdocker .`

_run_
`docker run -it terraformdocker /bin/bash`