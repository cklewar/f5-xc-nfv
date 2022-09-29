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

variable "custom_data_dir" {
  type    = string
  default = "custom_data"
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

variable "f5xc_aws_cred" {
  type    = string
  default = "ck-aws-01"
}

variable "f5xc_aws_tgw_name" {
  type        = string
  description = "TGW name"
  default     = "tgw-nfv"
}

variable "f5xc_aws_tgw_workload_subnet" {
  type    = string
  default = "192.168.168.0/26"
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

variable "aws_vpc_workload_name" {
  type        = string
  description = "Name for workload vpc"
  default     = "workload"
}

variable "aws_ec2_web_instance_name" {
  type    = string
  default = "web"
}

variable "aws_ec2_web_script_file_name" {
  type    = string
  default = "web.sh"
}

variable "aws_ec2_web_script_template_file_name" {
  type    = string
  default = "web.tftpl"
}

variable "aws_ec2_generator_script_template_file_name" {
  type        = string
  description = "EC2 instance userdata templatae file"
  default     = "generator.tftpl"
}

variable "aws_ec2_generator_instance_script_file_name" {
  type    = string
  default = "generator.sh"
}

variable "aws_ec2_generator_instance_name" {
  type        = string
  description = "EC2 traffic generator instance name"
  default     = "generator"
}

variable "aws_ec2_helper_instance_script_template_file_name" {
  type        = string
  description = "EC2 instance userdata templatae file"
  default     = "helper.tftpl"
}

variable "aws_ec2_helper_instance_script_file_name" {
  type    = string
  default = "helper.sh"
}

variable "aws_ec2_helper_instance_name" {
  type        = string
  description = "EC2 traffic generator instance name"
  default     = "helper"
}

variable "nfv_admin_username" {
  type        = string
  description = "NFV admin user name"
  default     = "admin"
}

variable "nfv_admin_password" {
  type        = string
  description = "NFC admin user password"
  default     = "Volterra123!"
}

variable "nfv_name" {
  type        = string
  description = "NFV name"
  default     = "bigip"
}

variable "nfv_node_name" {
  type        = string
  description = "NFV node name"
  default     = "bigip"
}

variable "nfv_description" {
  type        = string
  description = "NFV description"
  default     = ""
}

variable "nfv_domain_suffix" {
  type    = string
  default = "acmecorp-prod.f5xc.app"
}

variable "bigip_as3_rpm" {
  type    = string
  default = "f5-appsvcs-3.37.0-4.noarch.rpm"
}

variable "bigip_as3_rpm_url" {
  type    = string
  default = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.37.0/f5-appsvcs-3.37.0-4.noarch.rpm"
}

variable "gitea_version" {
  type    = string
  default = "1.17.2"
}

variable "gitea_password" {
  type    = string
  default = "password123!"
}