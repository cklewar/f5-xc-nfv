locals {
  f5xc_aws_tgw_name = format("%s-%s-%s", var.project_prefix, var.f5xc_aws_tgw_name, var.project_suffix)
  custom_tags_bigip       = {
    f5xc-tenant  = var.f5xc_tenant
    f5xc-feature = "aws-tgw-nfv-bigip"
  }
  custom_tags_pan       = {
    f5xc-tenant  = var.f5xc_tenant
    f5xc-feature = "aws-tgw-nfv-pan"
  }
}