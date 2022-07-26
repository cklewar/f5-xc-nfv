output "aws_vpc_workload_id" {
  value = module.vpc.aws_vpc_workload_id
}

output "aws_vpc_workload_subnet_public_id" {
  value = module.vpc.aws_subnet_public_id
}

output "aws_vpc_workload_subnet_private_id" {
  value = module.vpc.aws_subnet_private_id
}

output "nfv_virtual_server_ip" {
  value = module.nfv.nfv_virtual_server_ip
}

output "aws_ec2_instance_nfv_internal_interface_ip" {
  value = module.nfv.aws_ec2_instance_nfv_internal_interface_ip
}

output "aws_ec2_helper_instance_public_dns" {
  value = module.helper.aws_ec2_instance_public_dns
}