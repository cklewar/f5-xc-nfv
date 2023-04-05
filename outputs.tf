output "nfv" {
  value = {
    nfv = module.nfv_bigip_cluster.nfv
    tgw = module.tgw.f5xc_aws_tgw
  }
}