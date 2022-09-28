module "vpc_workload" {
  source             = "../modules/aws/vpc"
  aws_az_name        = var.f5xc_aws_az_name
  aws_region         = var.f5xc_aws_region
  aws_vpc_cidr_block = "172.16.40.0/22"
  aws_vpc_name       = format("%s-%s-%s", var.project_prefix, var.aws_vpc_workload_name, var.project_suffix)
  custom_tags        = {
    Name              = format("%s-aws-vpc-s-n-existing-sn-%s", var.project_prefix, var.project_suffix)
    Owner             = "c.klewar@f5.com"
    ves-io-site-name  = format("%s-aws-vpc-s-n-existing-sn-%s", var.project_prefix, var.project_suffix)
    ves-io-creator-id = "c.klewar@f5.com"
  }
}

provider "aws" {
  region = var.f5xc_aws_region
  alias  = var.f5xc_aws_region
}

module "aws_subnet" {
  source          = "../modules/aws/subnet"
  aws_vpc_id      = module.vpc_workload.aws_vpc["id"]
  aws_vpc_subnets = [
    {
      name                    = format("%s-aws-subnet-a-%s", var.project_prefix, var.project_suffix)
      map_public_ip_on_launch = true
      cidr_block              = "172.16.40.0/24"
      availability_zone       = var.f5xc_aws_az_name
      custom_tags             = {
        Name  = format("%s-aws-subnet-sli-%s", var.project_prefix, var.project_suffix)
        Owner = "c.klewar@f5.com"
      }
    },
    {
      name                    = format("%s-aws-subnet-b-%s", var.project_prefix, var.project_suffix)
      map_public_ip_on_launch = true
      cidr_block              = "172.16.41.0/24"
      availability_zone       = var.f5xc_aws_az_name
      custom_tags             = {
        Name  = format("%s-aws-subnet-slo-%s", var.project_prefix, var.project_suffix)
        Owner = "c.klewar@f5.com"
      }
    }
  ]
  custom_tags = {
    Owner = "c.klewar@f5.com"
  }

  providers = {
    aws = aws.us-east-2
  }
}

module "tgw" {
  source                         = "../modules/f5xc/site/aws/tgw"
  f5xc_api_p12_file              = var.f5xc_api_p12_file
  f5xc_api_url                   = var.f5xc_api_url
  f5xc_namespace                 = var.f5xc_namespace
  f5xc_tenant                    = var.f5xc_tenant
  f5xc_aws_region                = var.f5xc_aws_region
  f5xc_aws_cred                  = var.f5xc_aws_cred
  f5xc_aws_default_ce_sw_version = false
  f5xc_aws_default_ce_os_version = false
  f5xc_aws_tgw_name              = local.f5xc_aws_tgw_name
  f5xc_aws_tgw_no_worker_nodes   = true
  f5xc_aws_tgw_primary_ipv4      = "192.168.168.0/21"
  f5xc_aws_vpc_attachment_ids    = [module.vpc_workload.aws_vpc["id"]]
  f5xc_aws_tgw_az_nodes          = {
    node0 : {
      f5xc_aws_tgw_workload_subnet = "192.168.168.0/26", f5xc_aws_tgw_inside_subnet = "192.168.168.64/26",
      f5xc_aws_tgw_outside_subnet  = "192.168.168.128/26", f5xc_aws_tgw_az_name = var.f5xc_aws_az_name
    }
  }
  custom_tags = {
    Name  = local.f5xc_aws_tgw_name
    TTL   = -1
    Owner = var.owner_tag
  }
  public_ssh_key                       = var.public_ssh_key
  f5xc_aws_ce_os_version               = var.f5xc_aws_tgw_os_version
  f5xc_aws_ce_sw_version               = var.f5xc_aws_ce_sw_version
  f5xc_aws_tgw_vpc_attach_label_deploy = local.f5xc_aws_tgw_name
}

module "aws_tgw_wait_for_online" {
  depends_on     = [module.tgw]
  source         = "../modules/f5xc/status/site"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = var.f5xc_namespace
  f5xc_tenant    = var.f5xc_tenant
  f5xc_site_name = local.f5xc_aws_tgw_name
}

module "nfv" {
  source                  = "../modules/f5xc/nfv"
  f5xc_api_p12_file       = var.f5xc_api_p12_file
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
  f5xc_tgw_name           = format("%s-%s-%s", var.project_prefix, local.f5xc_aws_tgw_name, var.project_suffix)
  f5xc_aws_az_name        = var.f5xc_aws_az_name
  f5xc_aws_region         = var.f5xc_aws_region
  public_ssh_key          = var.public_ssh_key
  custom_tags             = {
    Name  = local.f5xc_aws_tgw_name
    TTL   = -1
    Owner = var.owner_tag
  }
}

module "ec2_web" {
  source                        = "../modules/aws/ec2"
  aws_ec2_instance_name         = "ck-ec2-instance-01"
  aws_ec2_instance_type         = "t2.small"
  aws_subnet_cidr               = "172.16.192.0/21"
  aws_ec2_public_interface_ips  = ["172.16.192.10"]
  aws_ec2_private_interface_ips = ["172.16.193.10"]
  aws_ec2_instance_data_key     = "ec2-instance-01"
  aws_ec2_instance_data         = {
    inline = [
      format("chmod +x /tmp/%s", var.aws_ec2_web_instance_script_file_name),
      format("sudo /tmp/%s", var.aws_ec2_web_instance_script_file_name)
    ]
    userdata = {
      GITEA_VERSION  = var.gitea_version
      GITEA_PASSWORD = var.gitea_password
    }
  }
  aws_ec2_instance_script_template = format("%s.tftpl", var.aws_ec2_web_instance_script_template_file_name)
  aws_ec2_instance_script_file     = format("%s.sh", var.aws_ec2_web_instance_script_file_name)
  aws_subnet_private_id            = element([for s in module.aws_subnet.aws_subnets : s], 1)
  aws_subnet_public_id             = element([for s in module.aws_subnet.aws_subnets : s], 0)
  aws_az_name                      = var.f5xc_aws_az_name
  aws_region                       = var.f5xc_aws_region
  ssh_private_key_file             = abspath("keys/key")
  ssh_public_key_file              = abspath("keys/key.pub")
  aws_vpc_id                       = module.vpc_workload.aws_vpc["id"]
  aws_ec2_instance_userdata_dirs   = [
    {
      name        = "instance_script"
      source      = abspath(format("../modules/ec2/_out/%s", format("%s.sh", var.aws_ec2_instance_script_file_name)))
      destination = format("/tmp/%s", format("%s.sh", var.aws_ec2_instance_script_file_name))
    },
    {
      name        = "additional_custom_data"
      source      = abspath(format("../modules/ec2/userdata/%s", var.aws_ec2_instance_script_file_name))
      destination = "/tmp/userdata"
    }
  ]
  custom_tags = {
    Name    = "ec2-instance-01"
    Version = "1"
    Owner   = "c.klewar@f5.com"
  }
}

module "web" {
  source                    = "../modules/aws/ec2"
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
  aws_ec2_transit_gateway            = module.tgw.f5xc_aws_tgw
  aws_ec2_instance_userdata_template = format("%s.tftpl", var.aws_ec2_web_instance_template)
  aws_ec2_instance_userdata_file     = format("%s.sh", var.aws_ec2_web_instance_template)
  aws_subnet_workload_private_cidr   = var.aws_subnet_workload_private_cidr
  aws_subnet_private_id              = module.vpc.aws_vpc[]
  aws_subnet_public_id               = module.vpc.aws_subnet_public_id
  aws_vpc_workload_id                = module.vpc_workload.aws_vpc["id"]
  aws_az_name                        = var.f5xc_aws_az_name
  aws_region                         = var.f5xc_aws_region
  ce_master_public_ip                = ""
  aws_ec2_instance_script_file       = ""
  aws_ec2_instance_script_template   = ""
  aws_ec2_instance_userdata_dirs     = []
  aws_ec2_private_interface_ips      = []
  aws_ec2_public_interface_ips       = []
  aws_subnet_cidr                    = ""
  aws_vpc_id                         = ""
  ssh_private_key_file               = ""
  ssh_public_key_file                = ""
}

module "generator" {
  source                    = "../modules/aws/ec2"
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
  source                    = "../modules/aws/ec2"
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