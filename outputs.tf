output "nfv" {
  value = {
    //nfv = module.nfv.nfv
    tgw = module.tgw.f5xc_aws_tgw
  }
}