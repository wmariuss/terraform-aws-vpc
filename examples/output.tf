# VPC output
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc.private_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnets}"]
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.vpc.nat_public_ips}"]
}

output "public_subnet_ids" {
  value = ["${module.vpc.public_subnet_ids}"]
}

output "private_subnet_ids" {
  value = ["${module.vpc.private_subnet_ids}"]
}

output "admin_subnets" {
  description = "List admin ID subnets"
  value       = "${module.vpc.admin_subnets}"
}

output "admin_subnets_cidr_blocks" {
  description = "List admin CIDR blocks subnets"
  value = "${module.vpc.admin_subnets_cidr_blocks}"
}
