terraform {
  required_version = ">= 1.3.0"
  cloud {
    organization = "cklewar"
    hostname     = "app.terraform.io"

    workspaces {
      name = "f5-xc-nfv-module"
    }
  }
  
  required_providers {
    volterra = {
      source = "volterraedge/volterra"
      version = "= 0.11.18"
    }
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.32.0"
    }
    local = ">= 2.2.3"
    null = ">= 3.1.1"
  }
}