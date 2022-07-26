terraform {
  backend "local" {
    workspace_dir = "../state/step1"
  }
}

module "vpc" {
  source                           = "../modules/vpc"
  project_prefix                   = var.project_prefix
  project_suffix                   = var.project_suffix
  aws_az_name                      = var.aws_az_name
  aws_region                       = var.aws_region
  aws_vpc_workload_cidr_block      = var.aws_vpc_workload_cidr_block
  aws_vpc_workload_name            = format("%s-%s-%s", var.project_prefix, var.aws_vpc_workload_name, var.project_suffix)
  aws_subnet_workload_private_cidr = var.aws_subnet_workload_private_cidr
  aws_subnet_workload_public_cidr  = var.aws_subnet_workload_public_cidr
  owner_tag                        = var.data[terraform.workspace].owner_tag
}

module "tgw" {
  source                      = "../modules/tgw"
  project_prefix              = var.project_prefix
  project_suffix              = var.project_suffix
  operating_system_version    = var.data[terraform.workspace].operating_system_version
  volterra_software_version   = var.data[terraform.workspace].volterra_software_version
  tenant                      = var.data[terraform.workspace].tenant
  namespace                   = var.namespace
  api_ca_cert                 = var.api_ca_cert
  api_cert                    = var.api_cert
  api_key                     = var.api_key
  api_p12_file                = var.data[terraform.workspace].api_p12_file
  api_url                     = var.data[terraform.workspace].api_url
  aws_az_name                 = var.aws_az_name
  aws_region                  = var.aws_region
  ssh_key                     = var.ssh_key
  tgw_aws_creds               = var.data[terraform.workspace].tgw_aws_creds
  tgw_instance_type           = var.tgw_instance_type
  tgw_name                    = format("%s-%s-%s", var.project_prefix, var.tgw_name, var.project_suffix)
  tgw_primary_ipv4            = var.tgw_primary_ipv4
  tgw_outside_subnet          = var.tgw_outside_subnet
  tgw_workload_subnet         = var.tgw_workload_subnet
  tgw_tf_action               = var.tgw_tf_action
  tgw_vpc_attach_label_deploy = var.data[terraform.workspace].tgw_vpc_attach_label_deploy
  aws_vpc_workload_id         = module.vpc.aws_vpc_workload_id
  owner_tag                   = var.data[terraform.workspace].owner_tag
}

module "nfv" {
  source               = "../modules/nfv"
  dependency           = module.tgw.this
  project_prefix       = var.project_prefix
  project_suffix       = var.project_suffix
  tenant               = var.data[terraform.workspace].tenant
  namespace            = var.namespace
  aws_region           = var.aws_region
  api_p12_file         = var.data[terraform.workspace].api_p12_file
  api_ca_cert          = var.api_ca_cert
  api_token            = var.data[terraform.workspace].api_token
  api_cert             = var.api_cert
  api_key              = var.api_key
  api_url              = var.data[terraform.workspace].api_url
  aws_az_name          = var.aws_az_name
  tgw_name             = format("%s-%s-%s", var.project_prefix, var.tgw_name, var.project_suffix)
  nfv_name             = format("%s-%s-%s", var.project_prefix, var.nfv_name, var.project_suffix)
  nfv_node_name        = format("%s-%s-%s", var.project_prefix, var.nfv_node_name, var.project_suffix)
  nfv_admin_username   = var.nfv_admin_username
  nfv_admin_password   = base64encode(var.nfv_admin_password)
  nfv_domain_suffix    = var.data[terraform.workspace].nfv_domain_suffix
  nfv_description      = var.nfv_description
  nfv_payload_file     = var.nfv_payload_file
  nfv_payload_template = var.nfv_payload_template
  nfv_svc_create_uri   = var.nfv_svc_create_uri
  nfv_svc_delete_uri   = var.nfv_svc_delete_uri
  nfv_svc_get_uri      = var.nfv_svc_get_uri
  owner_tag            = var.data[terraform.workspace].owner_tag
  ssh_key              = var.ssh_key
}

module "web" {
  source                    = "../modules/ec2"
  project_prefix            = var.project_prefix
  project_suffix            = var.project_suffix
  aws_ec2_instance_name     = format("%s-%s-%s", var.project_prefix, var.aws_ec2_web_instance_name, var.project_suffix)
  aws_ec2_instance_type     = var.aws_ec2_web_instance_type
  aws_ec2_instance_data_key = var.aws_ec2_web_instance_name
  aws_ec2_instance_data     = {
    inline = [
      format("chmod +x /tmp/%s", format("%s.sh", var.aws_ec2_web_instance_template)),
      format("sudo /tmp/%s", format("%s.sh", var.aws_ec2_web_instance_template))
    ]
    userdata = {
      prefix  = var.tgw_workload_subnet
      gateway = cidrhost(var.aws_subnet_workload_private_cidr, 1)
    }
  }
  aws_ec2_public_ips                 = var.aws_ec2_web_instance_public_ips
  aws_ec2_private_ips                = var.aws_ec2_web_instance_private_ips
  aws_ec2_transit_gateway            = module.tgw.this
  aws_ec2_instance_userdata_template = format("%s.tftpl", var.aws_ec2_web_instance_template)
  aws_ec2_instance_userdata_file     = format("%s.sh", var.aws_ec2_web_instance_template)
  aws_subnet_workload_private_cidr   = var.aws_subnet_workload_private_cidr
  aws_subnet_private_id              = module.vpc.aws_subnet_private_id
  aws_subnet_public_id               = module.vpc.aws_subnet_public_id
  aws_vpc_workload_id                = module.vpc.aws_vpc_workload_id
  aws_az_name                        = var.aws_az_name
  aws_region                         = var.aws_region
  owner_tag                          = var.data[terraform.workspace].owner_tag
  ssh_key                            = var.ssh_key
  ce_master_public_ip                = ""
}

module "generator" {
  source                    = "../modules/ec2"
  project_prefix            = var.project_prefix
  project_suffix            = var.project_suffix
  aws_ec2_instance_name     = format("%s-%s-%s", var.project_prefix, var.aws_ec2_generator_instance_name, var.project_suffix)
  aws_ec2_instance_type     = var.aws_ec2_generator_instance_type
  aws_ec2_public_ips        = var.aws_ec2_generator_instance_public_ips
  aws_ec2_private_ips       = var.aws_ec2_generator_instance_private_ips
  aws_ec2_transit_gateway   = module.tgw.this
  aws_ec2_instance_data_key = var.aws_ec2_generator_instance_name
  aws_ec2_instance_data     = {
    inline = [
      format("chmod +x /tmp/%s", format("%s.sh", var.aws_ec2_generator_instance_template)),
      format("sudo /tmp/%s", format("%s.sh", var.aws_ec2_generator_instance_template))
    ]
    userdata = {
      prefix  = var.tgw_workload_subnet
      gateway = cidrhost(var.aws_subnet_workload_private_cidr, 1)
      host    = module.tgw.ce_master_public_ip
      port    = 80
    }
  }
  aws_ec2_instance_userdata_template = format("%s.tftpl", var.aws_ec2_generator_instance_template)
  aws_ec2_instance_userdata_file     = format("%s.sh", var.aws_ec2_generator_instance_template)
  aws_subnet_workload_private_cidr   = var.aws_subnet_workload_private_cidr
  aws_subnet_private_id              = module.vpc.aws_subnet_private_id
  aws_subnet_public_id               = module.vpc.aws_subnet_public_id
  aws_vpc_workload_id                = module.vpc.aws_vpc_workload_id
  aws_az_name                        = var.aws_az_name
  aws_region                         = var.aws_region
  owner_tag                          = var.data[terraform.workspace].owner_tag
  ssh_key                            = var.ssh_key
  ce_master_public_ip                = module.tgw.ce_master_public_ip
}

module "helper" {
  source                    = "../modules/ec2"
  project_prefix            = var.project_prefix
  project_suffix            = var.project_suffix
  aws_ec2_instance_name     = format("%s-%s-%s", var.project_prefix, var.aws_ec2_helper_instance_name, var.project_suffix)
  aws_ec2_instance_type     = var.aws_ec2_helper_instance_type
  aws_ec2_public_ips        = var.aws_ec2_helper_instance_public_ips
  aws_ec2_private_ips       = var.aws_ec2_helper_instance_private_ips
  aws_ec2_transit_gateway   = module.tgw.this
  aws_ec2_instance_data_key = var.aws_ec2_helper_instance_name
  aws_ec2_instance_data     = {
    inline = [
      format("chmod +x /tmp/%s", format("%s.sh", var.aws_ec2_helper_instance_template)),
      format("sudo /tmp/%s %s %s %s", format("%s.sh", var.aws_ec2_helper_instance_template), module.nfv.aws_ec2_instance_nfv_internal_interface_ip, format("%s:%s", var.nfv_admin_username, var.nfv_admin_password), format("/tmp/%s", var.bigip_as3_rpm))
    ]
    userdata = {
      prefix            = var.tgw_workload_subnet
      gateway           = cidrhost(var.aws_subnet_workload_private_cidr, 1)
      bigip_as3_rpm_url = var.bigip_as3_rpm_url
      bigip_as3_rpm     = var.bigip_as3_rpm
    }
  }
  aws_ec2_instance_userdata_template = format("%s.tftpl", var.aws_ec2_helper_instance_template)
  aws_ec2_instance_userdata_file     = format("%s.sh", var.aws_ec2_helper_instance_template)
  aws_subnet_workload_private_cidr   = var.aws_subnet_workload_private_cidr
  aws_subnet_private_id              = module.vpc.aws_subnet_private_id
  aws_subnet_public_id               = module.vpc.aws_subnet_public_id
  aws_vpc_workload_id                = module.vpc.aws_vpc_workload_id
  aws_az_name                        = var.aws_az_name
  aws_region                         = var.aws_region
  owner_tag                          = var.data[terraform.workspace].owner_tag
  ssh_key                            = var.ssh_key
  ce_master_public_ip                = module.tgw.ce_master_public_ip
}