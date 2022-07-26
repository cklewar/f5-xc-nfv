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

variable "deployment" {
  type    = string
  default = "cosmic"
}

variable "api_cert" {
  type    = string
  default = ""
}

variable "api_key" {
  type    = string
  default = ""
}

variable "api_ca_cert" {
  type    = string
  default = ""
}

variable "namespace" {
  type = string
}

variable "tgw_name" {
  type        = string
  description = "TGW name"
}

variable "tgw_instance_type" {
  type        = string
  description = "TGW instance type"
}

variable "tgw_primary_ipv4" {
  type = string
}

variable "tgw_outside_subnet" {
  type = string
}

variable "tgw_workload_subnet" {
  type = string
}

variable "tgw_tf_action" {
  type        = string
  description = "Terraform provider action e.g. apply / destroy / plan"
}

variable "ssh_key" {
  type        = string
  description = "Public ssh key used for instances"
}

variable "aws_region" {
  type        = string
  description = "AWS region name"
}

variable "aws_az_name" {
  type        = string
  description = "AWS availability zone name"
}

variable "aws_vpc_workload_cidr_block" {
  type        = string
  description = "vpc cidr block for workload vpc"
}

variable "aws_vpc_workload_name" {
  type        = string
  description = "Name for workload vpc"
}

variable "aws_subnet_workload_public_cidr" {
  type        = string
  description = "Workload public net subnet"
}

variable "aws_subnet_workload_private_cidr" {
  type        = string
  description = "Workload private net subnet"
}

variable "aws_ec2_web_instance_template" {
  type = string
  description = "EC2 instance userdata templatae file"
}

variable "aws_ec2_web_instance_name" {
  type        = string
  description = "EC2 web instance name"
}

variable "aws_ec2_web_instance_type" {
  type        = string
  description = "EC2 web instance type"
}

variable "aws_ec2_web_instance_private_ips" {
  type        = list(string)
  description = "AWS ec2 instance private interface static IP"
}

variable "aws_ec2_web_instance_public_ips" {
  type        = list(string)
  description = "AWS ec2 instance public interface static IP"
}

variable "aws_ec2_generator_instance_template" {
  type = string
  description = "EC2 instance userdata templatae file"
}

variable "aws_ec2_generator_instance_name" {
  type        = string
  description = "EC2 traffic generator instance name"
}

variable "aws_ec2_generator_instance_type" {
  type        = string
  description = "EC2 traffic generator instance type"
}

variable "aws_ec2_generator_instance_private_ips" {
  type        = list(string)
  description = "AWS ec2 instance private interface static IP"
}

variable "aws_ec2_generator_instance_public_ips" {
  type        = list(string)
  description = "AWS ec2 instance public interface static IP"
}

variable "aws_ec2_helper_instance_template" {
  type = string
  description = "EC2 instance userdata templatae file"
}

variable "aws_ec2_helper_instance_name" {
  type        = string
  description = "EC2 traffic generator instance name"
}

variable "aws_ec2_helper_instance_type" {
  type        = string
  description = "EC2 traffic generator instance type"
}

variable "aws_ec2_helper_instance_private_ips" {
  type        = list(string)
  description = "AWS ec2 instance private interface static IP"
}

variable "aws_ec2_helper_instance_public_ips" {
  type        = list(string)
  description = "AWS ec2 instance public interface static IP"
}

variable "nfv_svc_create_uri" {
  type    = string
  default = "config/namespaces/%s/nfv_services"
}

variable "nfv_svc_delete_uri" {
  type    = string
  default = "config/namespaces/%s/nfv_services"
}

variable "nfv_svc_get_uri" {
  type    = string
  default = "config/namespaces/%s/nfv_services/%s"
}

variable "nfv_payload_template" {
  type    = string
  default = "payload.tftpl"
}
variable "nfv_payload_file" {
  type    = string
  default = "payload.json"
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

variable "nfv_name" {
  type        = string
  description = "NFV name"
}

variable "nfv_description" {
  type        = string
  description = "NFV description"
}

variable "bigip_as3_rpm" {
  type = string
}

variable "bigip_as3_rpm_url" {
  type = string
}