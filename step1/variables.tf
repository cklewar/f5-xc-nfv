variable "project_prefix" {
  type        = string
  description = "prefix string put in front of string"
  default     = "f5xc"
}

variable "project_suffix" {
  type        = string
  description = "prefix string put at the end of string"
  default     = "01"
}

variable "owner_tag" {
  type    = string
  default = "c.klewar@f5.com"
}

variable "f5xc_api_p12_file" {
  type    = string
  default = "/Users/c.klewar/Projects/github.com/cklewar/volterra/cert/playground.staging.api-creds.p12"
}

variable "f5xc_api_url" {
  type    = string
  default = "https://playground.staging.volterra.us/api"
}

variable "f5xc_api_token" {
  type    = string
  default = "LhqZ7DZgLxNk3ib/DUydAc+8JPQ="
}

variable "f5xc_tenant" {
  type    = string
  default = "playground-wtppvaog"
}

variable "f5xc_namespace" {
  type    = string
  default = "system"
}

variable "f5xc_virtual_k8s_namespace" {
  type    = string
  default = "default"
}

variable "f5xc_aws_cred" {
  type    = string
  default = "ck-aws-01"
}

/*variable "data" {
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
}*/

variable "f5xc_aws_tgw_name" {
  type        = string
  description = "TGW name"
}

variable "f5xc_aws_tgw_instance_type" {
  type        = string
  description = "TGW instance type"
}

variable "f5xc_aws_tgw_primary_ipv4" {
  type = string
}

variable "tf5xc_aws_gw_outside_subnet" {
  type = string
}

variable "f5xc_aws_tgw_workload_subnet" {
  type = string
}

variable "f5xc_aws_tgw_os_version" {
  type = string
}

variable "f5xc_aws_ce_sw_version" {
  type = string
}

variable "public_ssh_key" {
  type        = string
  description = "Public ssh key used for instances"
}

variable "f5xc_aws_region" {
  type        = string
  description = "AWS region name"
  default     = "us-east-2"
}

variable "f5xc_aws_az_name" {
  type        = string
  description = "AWS availability zone name"
  default     = "us-east-2a"
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
  type        = string
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
  type        = string
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
  type        = string
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

variable "nfv_domain_suffix" {
  type = string
}

variable "bigip_as3_rpm" {
  type = string
}

variable "bigip_as3_rpm_url" {
  type = string
}