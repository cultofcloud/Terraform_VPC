## Terraform for VPC

This repository contains the projects that will create VPC's for multiple environment and regions

## usage

Use the var.tf file in order to change the enviornment or the region to build the vpc. Update the terraform.tfvars file with the AWS access and secret key.

## Commands to build

### To check the plan of what is going to be built

```
terraform plan
```

### To build the  vpc

```
terraform apply
```