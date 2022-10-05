locals {
  template_output_dir_path = abspath("_out/")
  template_input_dir_path  = abspath("templates/")
  f5xc_aws_tgw_name        = format("%s-%s-%s", var.project_prefix, var.f5xc_aws_tgw_name, var.project_suffix)
}