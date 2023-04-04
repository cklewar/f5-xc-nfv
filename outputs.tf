output "nfv" {
  value = {
    nfv = module.nfv.nfv
    tgw = module.tgw.f5xc_aws_tgw
  }
}

output "pan_commands" {
  value = module.nfv.nfv["pan_commands"]
}