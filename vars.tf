# Specify the VPC Name, Region and Environment

variable "vpc_name" {
  default = "qa-nonprod-ap"
}

variable "AWS_REGION" {
  default = "us-west-2"
}

variable "env" {
  default = "qa" #specify the environment
}

# Variables for AWS Keys
variable AWS_ACCESS_KEY {}
variable AWS_SECRET_KEY {}

# Variables for VPC and Subnets
variable "vpc_cidr_block" {
  default = "10.180.0.0/16"
}

# Variables for Availability Zones
variable "vpc_azs" {
  type = "map"
  default = {
    "us-west-1"      = "us-west-1a,us-west-1b"
    "us-west-2"      = "us-west-2a,us-west-2b,us-west-2c"
    "us-east-1"      = "us-east-1a,us-east-1b,us-east-1c,us-east-1e"
    "ap-southeast-1" = "ap-southeast-1a,ap-southeast-1b"
    "ap-southeast-2" = "ap-southeast-2a,ap-southeast-2b,ap-southeast-2c"
    "eu-west-1"      = "eu-west-1a,eu-west-1b,eu-west-1c"
  }
}

# Variables to store the subnet values
variable "vpc_cidr_pub_sub" {
  default = ["10.180.32.0/21", "10.180.40.0/21", "10.180.48.0/21"]
}

variable "vpc_cidr_priv_sub" {
  default = ["10.180.88.0/21", "10.180.96.0/21", "10.180.104.0/21"]
}

variable "vpc_cidr_data_sub" {
  default = ["10.180.200.0/21", "10.180.208.0/21", "10.180.216.0/21"]
}

variable "vpc_cidr_app_sub" {
  default = ["10.180.144.0/21", "10.180.152.0/21", "10.180.160.0/21"]
}