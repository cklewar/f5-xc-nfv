output "nfv_virtual_server_ip" {
  value = module.nfv.nfv["virtual_server_ip"]
}

output "aws_ec2_instance_nfv_internal_interface_ip" {
  value = module.nfv.nfv["internal_interface_ip"]
}