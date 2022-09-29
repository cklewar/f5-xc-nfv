output "aws_vpc_workload_id" {
  value = module.vpc_workload.aws_vpc["id"]
}

output "aws_subnet_workload_public_id" {
  depends_on = [module.aws_subnet]
  value = module.aws_subnet.aws_subnets[format("%s-aws-subnet-public-%s", var.project_prefix, var.project_suffix)]["id"]
}

output "aws_workload_subnet_private_id" {
  depends_on = [module.aws_subnet]
  value = module.aws_subnet.aws_subnets[format("%s-aws-subnet-private-%s", var.project_prefix, var.project_suffix)]["id"]
}

output "nfv_virtual_server_ip" {
  value = module.nfv.nfv_virtual_server_ip
}

output "aws_ec2_instance_nfv_internal_interface_ip" {
  value = module.nfv.aws_ec2_instance_nfv_internal_interface_ip
}

output "aws_ec2_helper_instance_public_dns" {
  value = module.helper.aws_ec2_instance["public_dns"]
}