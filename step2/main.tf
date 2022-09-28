terraform {
  backend "local" {
    workspace_dir = "../state/step2"
  }
}

output "aws_vpc_workload_id" {
  value = data.terraform_remote_state.step1.outputs.aws_vpc_workload_id
}

output "aws_vpc_workload_subnet_private_id" {
  value = data.terraform_remote_state.step1.outputs.aws_vpc_workload_subnet_private_id
}

output "nfv_virtual_server_ip" {
  value = data.terraform_remote_state.step1.outputs.nfv_virtual_server_ip
}

output "aws_ec2_instance_nfv_internal_interface_ip" {
  value = data.terraform_remote_state.step1.outputs.aws_ec2_instance_nfv_internal_interface_ip
}

output "aws_ec2_helper_instance_public_dns" {
  value = data.terraform_remote_state.step1.outputs.aws_ec2_helper_instance_public_dns
}

module "bigip" {
  source                         = "../modules_old/bigip"
  project_prefix                 = var.project_prefix
  project_suffix                 = var.project_suffix
  nfv_node_name                  = format("%s-%s-%s", var.project_prefix, var.nfv_node_name, var.project_suffix)
  nfv_domain_suffix              = var.data[terraform.workspace].nfv_domain_suffix
  bigip_admin_username           = var.nfv_admin_username
  bigip_admin_password           = var.nfv_admin_password
  bigip_as3_rpm                  = var.bigip_as3_rpm
  bigip_as3_rpm_url              = var.bigip_as3_rpm_url
  bigip_ltm_pool_name            = var.bigip_ltm_pool_name
  bigip_ltm_monitor_name         = var.bigip_ltm_monitor_name
  bigip_ltm_pool_node_ip         = element(var.aws_ec2_web_instance_private_ips, 0)
  bigip_ltm_pool_node_name       = var.bigip_ltm_pool_node_name
  bigip_ltm_virtual_server_ip    = data.terraform_remote_state.step1.outputs.nfv_virtual_server_ip
  bigip_ltm_virtual_server_name  = var.bigip_ltm_virtual_server_name
  bigip_as3_awaf_policy          = var.bigip_as3_awaf_policy
  bigip_as3_awaf_policy_template = var.bigip_as3_awaf_policy_template
  bigip_interface_internal_ip    = data.terraform_remote_state.step1.outputs.aws_ec2_instance_nfv_internal_interface_ip
  bigip_tenant                   = var.bigip_tenant
  aws_ec2_instance_public_ip     = data.terraform_remote_state.step1.outputs.aws_ec2_helper_instance_public_dns
  owner_tag                      = var.data[terraform.workspace].owner_tag
}