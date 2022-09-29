terraform {
  required_version = ">= 1.3.0"
  cloud {
    organization = "cklewar"

    workspaces {
      name = "f5-xc-nfv-bigip-module"
    }
  }

  /*backend "local" {
    workspace_dir = "../state/step1"
  }*/

  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = ">= 0.11.12"
      configuration_aliases = [ volterra.alternate ]
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.32.0"
    }

    local = ">= 2.2.3"
    null  = ">= 3.1.1"
  }
}