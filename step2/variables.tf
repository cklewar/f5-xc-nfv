variable "data" {
  type = map(
    object({
      operating_system_version    = string
      volterra_software_version   = string
      api_url                     = string
      api_p12_file                = string
      api_token                   = string
      tenant                      = string
      tgw_aws_creds               = string
      nfv_domain_suffix           = string
      tgw_vpc_attach_label_deploy = string
      owner_tag                   = string
    })
  )
}

variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
}

variable "nfv_node_name" {
  type        = string
  description = "NFV node name"
}

variable "nfv_admin_username" {
  type        = string
  description = "NFV admin user name"
}

variable "nfv_admin_password" {
  type        = string
  description = "NFC admin user password"
}

variable "bigip_ltm_pool_name" {
  type    = string
  default = "demo-pool"
}

variable "bigip_ltm_pool_node_name" {
  type    = string
  default = "demo-node-1"
}

variable "bigip_ltm_monitor_name" {
  type    = string
  default = "demo-http-monitor"
}

variable "bigip_ltm_virtual_server_name" {
  type    = string
  default = "demo-virtual-server-http"
}

variable "bigip_as3_rpm" {
  type = string
}

variable "bigip_as3_rpm_url" {
  type = string
}

variable "bigip_as3_awaf_policy_template" {
  type = string
}

variable "bigip_as3_awaf_policy" {
  type = string
}

variable "bigip_tenant" {
  type = string
}

variable "aws_ec2_web_instance_private_ips" {
  type        = list(string)
  description = "AWS ec2 instance private interface static IP"
}
