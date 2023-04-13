# F5-XC-NFV
This repository consists of Terraform templates to bring up a F5XC NFV environment.

## Usage

- Clone this repo with: `git clone --recurse-submodules https://github.com/cklewar/f5-xc-nfv`
- Enter repository directory with: `cd f5-xc-nfv`
- Obtain F5XC API certificate file from Console and save it to `cert` directory
- Pick and choose from below examples and add mandatory input data and copy data into file `main.tf.example`.
- Rename file __main.tf.example__ to __main.tf__ with: `rename main.tf.example main.tf`
- Change backend settings in `versions.tf` file to fit your environment needs
- Initialize with: `terraform init`
- Apply with: `terraform apply -auto-approve` or destroy with: `terraform destroy -auto-approve`

## Common module variables

```hcl
provider "aws" {
  region = var.f5xc_aws_region
  alias  = "default"
}

provider "volterra" {
  api_p12_file = var.f5xc_api_p12_file
  url          = var.f5xc_api_url
  alias        = "default"
}
```

## NFV BigIP single node module usage example

````hcl
module "tgw" {
  source                         = "./modules/f5xc/site/aws/tgw"
  f5xc_tenant                    = var.f5xc_tenant
  f5xc_api_url                   = var.f5xc_api_url
  f5xc_aws_cred                  = var.f5xc_aws_cred
  f5xc_api_token                 = var.f5xc_api_token
  f5xc_namespace                 = var.f5xc_namespace
  f5xc_aws_region                = var.f5xc_aws_region
  f5xc_aws_tgw_name              = local.f5xc_aws_tgw_name
  f5xc_aws_tgw_owner             = var.f5xc_aws_tgw_owner
  f5xc_aws_tgw_primary_ipv4      = "192.168.168.0/21"
  f5xc_aws_tgw_no_worker_nodes   = true
  f5xc_aws_default_ce_sw_version = true
  f5xc_aws_default_ce_os_version = true
  f5xc_aws_tgw_az_nodes          = {
    node0 : {
      f5xc_aws_tgw_workload_subnet = "192.168.168.0/26", f5xc_aws_tgw_inside_subnet = "192.168.168.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.168.128/26", f5xc_aws_tgw_az_name = var.f5xc_aws_az_name
    }
  }
  custom_tags    = local.custom_tags
  ssh_public_key = file(var.ssh_public_key_file)
  providers      = {
    aws      = aws.default
    volterra = volterra.default
  }
}

module "apply_timeout_workaround" {
  source         = "./modules/utils/timeout"
  depend_on      = module.tgw.f5xc_aws_tgw
  create_timeout = "120s"
  delete_timeout = "180s"
}

module "nfv" {
  depends_on                   = [module.apply_timeout_workaround, module.tgw.f5xc_aws_tgw]
  source                       = "./modules/f5xc/nfv/aws"
  f5xc_tenant                  = var.f5xc_tenant
  f5xc_api_url                 = var.f5xc_api_url
  f5xc_nfv_type                = var.f5xc_nfv_type_f5_big_ip_aws_service
  f5xc_nfv_name                = format("%s-%s-%s", var.project_prefix, var.nfv_name, var.project_suffix)
  f5xc_api_token               = var.f5xc_api_token
  f5xc_namespace               = var.f5xc_namespace
  f5xc_nfv_domain_suffix       = var.nfv_domain_suffix
  f5xc_nfv_admin_password      = var.nfv_admin_password
  f5xc_nfv_admin_username      = var.nfv_admin_username
  f5xc_nfv_aws_tgw_site_params = {
    name      = module.tgw.f5xc_aws_tgw["site_name"]
    tenant    = var.f5xc_tenant
    namespace = module.tgw.f5xc_aws_tgw["namespace"]
  }
  f5xc_aws_nfv_nodes = {
    "${var.project_prefix}-${var.nfv_name}-node1-${var.project_suffix}" = {
      aws_az_name          = var.f5xc_aws_az_name
      automatic_prefix     = true
      reserved_mgmt_subnet = false
    }
  }
  f5xc_https_mgmt_advertise_on_internet_default_vip = true
  ssh_public_key                                    = file(var.ssh_public_key_file)
  custom_tags                                       = local.custom_tags
  providers                                         = {
    aws      = aws.default
    volterra = volterra.default
  }
}

output "nfv" {
  value = merge(module.nfv.nfv,
    {
      public_ip  = module.tgw.f5xc_aws_tgw["public_ip"],
      public_dns = module.tgw.f5xc_aws_tgw["public_dns"]
    }
  )
}
````

## NFV BigIP cluster module usage example

```hcl
module "tgw" {
  source                         = "./modules/f5xc/site/aws/tgw"
  f5xc_tenant                    = var.f5xc_tenant
  f5xc_api_url                   = var.f5xc_api_url
  f5xc_aws_cred                  = var.f5xc_aws_cred
  f5xc_api_token                 = var.f5xc_api_token
  f5xc_namespace                 = var.f5xc_namespace
  f5xc_aws_region                = var.f5xc_aws_region
  f5xc_aws_tgw_name              = local.f5xc_aws_tgw_name
  f5xc_aws_tgw_owner             = var.f5xc_aws_tgw_owner
  f5xc_aws_tgw_primary_ipv4      = "192.168.168.0/21"
  f5xc_aws_tgw_no_worker_nodes   = true
  f5xc_aws_default_ce_sw_version = true
  f5xc_aws_default_ce_os_version = true
  f5xc_aws_vpc_attachment_ids    = []
  f5xc_aws_tgw_az_nodes          = {
    node0 : {
      f5xc_aws_tgw_workload_subnet = "192.168.168.0/26",
      f5xc_aws_tgw_inside_subnet   = "192.168.168.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.168.128/26",
      f5xc_aws_tgw_az_name         = format("%sa", var.f5xc_aws_region)
    },
    node1 : {
      f5xc_aws_tgw_workload_subnet = "192.168.169.0/26",
      f5xc_aws_tgw_inside_subnet   = "192.168.169.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.169.128/26",
      f5xc_aws_tgw_az_name         = format("%sb", var.f5xc_aws_region)
    },
    node2 : {
      f5xc_aws_tgw_workload_subnet = "192.168.170.0/26",
      f5xc_aws_tgw_inside_subnet   = "192.168.170.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.170.128/26",
      f5xc_aws_tgw_az_name         = format("%sc", var.f5xc_aws_region)
    }
  }
  custom_tags    = local.custom_tags_bigip
  ssh_public_key = file(var.ssh_public_key_file)
  providers      = {
    aws      = aws.default
    volterra = volterra.default
  }
}

module "nfv" {
  depends_on                         = [module.apply_timeout_workaround, module.tgw.f5xc_aws_tgw]
  source                             = "./modules/f5xc/nfv/aws"
  f5xc_tenant                        = var.f5xc_tenant
  f5xc_api_url                       = var.f5xc_api_url
  f5xc_nfv_type                      = var.f5xc_nfv_type_f5_big_ip_aws_service
  f5xc_nfv_name                      = format("%s-%s-%s", var.project_prefix, var.nfv_name, var.project_suffix)
  f5xc_api_token                     = var.f5xc_api_token
  f5xc_namespace                     = var.f5xc_namespace
  f5xc_nfv_domain_suffix             = var.nfv_domain_suffix
  f5xc_nfv_admin_password            = var.nfv_admin_password
  f5xc_nfv_admin_username            = var.nfv_admin_username
  f5xc_https_mgmt_do_not_advertise   = true
  f5xc_https_mgmt_default_https_port = true
  f5xc_nfv_aws_tgw_site_params       = {
    name      = module.tgw.f5xc_aws_tgw["site_name"]
    tenant    = var.f5xc_tenant
    namespace = module.tgw.f5xc_aws_tgw["namespace"]
  }
  f5xc_aws_nfv_nodes = {
    "node1" = {
      aws_az_name          = format("%s%s", var.f5xc_aws_region, "a")
      automatic_prefix     = true
      reserved_mgmt_subnet = true
    }
    "node2" = {
      aws_az_name          = format("%s%s", var.f5xc_aws_region, "b")
      automatic_prefix     = true
      reserved_mgmt_subnet = true
    }
  }
  f5xc_https_mgmt_advertise_on_internet_default_vip = true
  enable_f5xc_nfv_wait_for_online                   = true
  ssh_public_key                                    = file(var.ssh_public_key_file)
  custom_tags                                       = local.custom_tags_bigip
  providers                                         = {
    aws      = aws.default
    volterra = volterra.default
  }
}
```

## NFV Palo Alto cluster module usage example

```hcl
module "tgw" {
  source                         = "./modules/f5xc/site/aws/tgw"
  f5xc_tenant                    = var.f5xc_tenant
  f5xc_api_url                   = var.f5xc_api_url
  f5xc_aws_cred                  = var.f5xc_aws_cred
  f5xc_api_token                 = var.f5xc_api_token
  f5xc_namespace                 = var.f5xc_namespace
  f5xc_aws_region                = var.f5xc_aws_region
  f5xc_aws_tgw_name              = local.f5xc_aws_tgw_name
  f5xc_aws_tgw_owner             = var.f5xc_aws_tgw_owner
  f5xc_aws_tgw_primary_ipv4      = "192.168.168.0/21"
  f5xc_aws_tgw_no_worker_nodes   = true
  f5xc_aws_default_ce_sw_version = true
  f5xc_aws_default_ce_os_version = true
  f5xc_aws_vpc_attachment_ids    = []
  f5xc_aws_tgw_az_nodes          = {
    node0 : {
      f5xc_aws_tgw_workload_subnet = "192.168.168.0/26",
      f5xc_aws_tgw_inside_subnet   = "192.168.168.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.168.128/26",
      f5xc_aws_tgw_az_name         = format("%sa", var.f5xc_aws_region)
    },
    node1 : {
      f5xc_aws_tgw_workload_subnet = "192.168.169.0/26",
      f5xc_aws_tgw_inside_subnet   = "192.168.169.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.169.128/26",
      f5xc_aws_tgw_az_name         = format("%sb", var.f5xc_aws_region)
    },
    node2 : {
      f5xc_aws_tgw_workload_subnet = "192.168.170.0/26",
      f5xc_aws_tgw_inside_subnet   = "192.168.170.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.170.128/26",
      f5xc_aws_tgw_az_name         = format("%sc", var.f5xc_aws_region)
    }
  }
  custom_tags    = local.custom_tags_pan
  ssh_public_key = file(var.ssh_public_key_file)
  providers      = {
    aws      = aws.default
    volterra = volterra.default
  }
}

module "apply_timeout_workaround" {
  source         = "./modules/utils/timeout"
  depend_on      = module.tgw.f5xc_aws_tgw
  create_timeout = "120s"
  delete_timeout = "180s"
}

module "nfv" {
  depends_on                   = [module.apply_timeout_workaround, module.tgw.f5xc_aws_tgw]
  source                       = "./modules/f5xc/nfv/aws"
  f5xc_tenant                  = var.f5xc_tenant
  f5xc_api_url                 = var.f5xc_api_url
  f5xc_nfv_type                = var.f5xc_nfv_type_palo_alto_fw_service
  f5xc_nfv_name                = format("%s-%s-%s", var.project_prefix, "pan", var.project_suffix)
  f5xc_api_token               = var.f5xc_api_token
  f5xc_namespace               = var.f5xc_namespace
  f5xc_pan_ami_bundle1         = true
  f5xc_nfv_domain_suffix       = var.nfv_domain_suffix
  f5xc_nfv_admin_password      = "" # disabled
  f5xc_nfv_admin_username      = "" # disabled
  f5xc_pan_disable_panorama    = true
  f5xc_nfv_aws_tgw_site_params = {
    name      = module.tgw.f5xc_aws_tgw["site_name"]
    tenant    = var.f5xc_tenant
    namespace = module.tgw.f5xc_aws_tgw["namespace"]
  }
  f5xc_aws_nfv_nodes = {
    "node1" = {
      aws_az_name          = format("%sa", var.f5xc_aws_region)
      automatic_prefix     = true
      reserved_mgmt_subnet = false
    },
    "node2" = {
      aws_az_name          = format("%sb", var.f5xc_aws_region)
      automatic_prefix     = true
      reserved_mgmt_subnet = false
    }
  }
  f5xc_https_mgmt_do_not_advertise                  = true
  f5xc_https_mgmt_default_https_port                = true
  f5xc_https_mgmt_advertise_on_internet_default_vip = true
  enable_f5xc_nfv_wait_for_online                   = true
  ssh_public_key                                    = file(var.ssh_public_key_file)
  custom_tags                                       = local.custom_tags_pan
  providers                                         = {
    aws      = aws.default
    volterra = volterra.default
  }
}

output "pan_commands" {
  value = module.nfv.nfv["pan_commands"]
}
```