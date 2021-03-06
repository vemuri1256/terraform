#
# MAINTAINER Vitaliy Natarov "vitaliy.natarov@yahoo.com"
#

terraform {
  required_version = "~> 0.12.12"
}

provider "aws" {
    version                 = "~> 2.36"
    region                  = "us-west-2"
    shared_credentials_file = pathexpand("~/.aws/credentials")
    profile                 = "default"
    max_retries             = 3
}

module "provisioners" {
    source                                      = "../../modules/null_resource"

    #
    enable_file_provisioner                     = true
    enable_connection_by_login                  = true
    # or
    # enable_connection_by_key                  = true


    enable_provisioner_local_exec_command       = true
    provisioner_local_exec_command_command      = "echo 'test text' >> test.txt"
    provisioner_local_exec_command_interpreter  = []
    provisioner_local_exec_command_environment  = {
        FOO = "bar"
        BAR = 1
        BAZ = "true"
    }
}
