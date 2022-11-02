output "nfv" {
  value = merge(module.nfv.nfv,
    {
      public_ip  = module.tgw.f5xc_aws_tgw["public_ip"],
      public_dns = module.tgw.f5xc_aws_tgw["public_dns"]
    }
  )
}