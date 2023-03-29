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

variable "f5xc_aws_tgw_owner" {
  type    = string
  default = "c.klewar@ves.io"
}

variable "f5xc_api_p12_file" {
  type    = string
}

variable "f5xc_api_url" {
  type    = string
}

variable "f5xc_api_token" {
  type    = string
}

variable "f5xc_api_cert" {
  type    = string
  default = ""
}

variable "f5xc_api_key" {
  type    = string
  default = ""
}

variable "f5xc_api_ca_cert" {
  type    = string
  default = ""
}

variable "f5xc_tenant" {
  type    = string
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
  description = "AWS TGW name"
  default     = "tgw-nfv"
}

variable "f5xc_aws_region" {
  type        = string
  description = "AWS region name"
  default     = "us-west-1"
}

variable "f5xc_aws_az_name" {
  type        = string
  description = "AWS availability zone name"
  default     = "us-west-1a"
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
  default     = "bigip"
}

variable "nfv_domain_suffix" {
  type    = string
  default = "adn-prod.helloclouds.app"
}

variable "f5xc_nfv_type_f5_big_ip_aws_service" {
  type    = string
  default = "f5_big_ip_aws_service"
}

variable "f5xc_nfv_type_palo_alto_fw_service" {
  type    = string
  default = "palo_alto_fw_service"
}

variable "ssh_public_key_file" {
  type    = string
}