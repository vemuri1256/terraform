#
# MAINTAINER Vitaliy Natarov "vitaliy.natarov@yahoo.com"
#
terraform {
    required_version = "~> 0.12.12"
}

provider "aws" {
    region                  = "us-east-1"
    shared_credentials_file = pathexpand("~/.aws/credentials")
}

module "servicecatalog" {
    source                          = "../../modules/servicecatalog"
    name                            = "TEST"
    environment                     = "stage"
}
