# F5-XC-NFV
This repository consists of Terraform templates to bring up a F5XC NFV environment.

## Usage

- Clone this repo with: `git clone --recurse-submodules https://github.com/cklewar/f5-xc-nfv`
- Enter repository directory with: `cd f5-xc-nfv`
- Obtain F5XC API certificate file from Console and save it to `cert` directory
- Pick and choose from below examples and add mandatory input data and copy data into file `main.tf.example`.
- Rename file __main.tf.example__ to __main.tf__ with: `rename main.tf.example main.tf`
- Initialize with: `terraform init`
- Apply with: `terraform apply -auto-approve` or destroy with: `terraform destroy -auto-approve`

## NFV module usage example

````hcl
module "tgw" {
  source                               = "./modules/f5xc/site/aws/tgw"
  f5xc_api_p12_file                    = var.f5xc_api_p12_file
  f5xc_api_url                         = var.f5xc_api_url
  f5xc_namespace                       = var.f5xc_namespace
  f5xc_tenant                          = var.f5xc_tenant
  f5xc_aws_region                      = var.f5xc_aws_region
  f5xc_aws_cred                        = var.f5xc_aws_cred
  f5xc_aws_default_ce_sw_version       = true
  f5xc_aws_default_ce_os_version       = true
  f5xc_aws_tgw_name                    = local.f5xc_aws_tgw_name
  f5xc_aws_tgw_no_worker_nodes         = true
  f5xc_aws_tgw_primary_ipv4            = "192.168.168.0/21"
  f5xc_aws_tgw_az_nodes                = {
    node0 : {
      f5xc_aws_tgw_workload_subnet = var.f5xc_aws_tgw_workload_subnet, f5xc_aws_tgw_inside_subnet = "192.168.168.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.168.128/26", f5xc_aws_tgw_az_name = var.f5xc_aws_az_name
    }
  }
  custom_tags = {
    Name  = local.f5xc_aws_tgw_name
    TTL   = -1
    Owner = var.owner_tag
  }
  public_ssh_key = file(var.ssh_public_key_file)
}

module "nfv" {
  depends_on              = [module.aws_tgw_wait_for_online]
  source                  = "./modules/f5xc/nfv"
  f5xc_api_token          = var.f5xc_api_token
  f5xc_api_url            = var.f5xc_api_url
  f5xc_namespace          = var.f5xc_namespace
  f5xc_tenant             = var.f5xc_tenant
  f5xc_nfv_admin_password = var.nfv_admin_password
  f5xc_nfv_admin_username = var.nfv_admin_username
  f5xc_nfv_domain_suffix  = var.nfv_domain_suffix
  f5xc_nfv_description    = var.nfv_description
  f5xc_nfv_node_name      = format("%s-%s-%s", var.project_prefix, var.nfv_node_name, var.project_suffix)
  f5xc_nfv_name           = format("%s-%s-%s", var.project_prefix, var.nfv_name, var.project_suffix)
  f5xc_tgw_name           = local.f5xc_aws_tgw_name
  f5xc_aws_az_name        = var.f5xc_aws_az_name
  f5xc_aws_region         = var.f5xc_aws_region
  public_ssh_key          = file(var.ssh_public_key_file)
  custom_tags             = {
    Name  = local.f5xc_aws_tgw_name
    TTL   = -1
    Owner = var.owner_tag
  }
  providers = {
    aws      = aws.us-east-2
    volterra = volterra.default
  }
}
````