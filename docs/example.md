# Example

```hcl
# Create a file named main.tf and add:

module "vpc" {
  source = "<URL+VERSION>"

  name = "project_name"

  cidr = "10.238.0.0/16"

  availability_zones  = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
  private_subnets     = ["10.238.1.0/24", "10.238.2.0/24", "10.238.3.0/24"]
  public_subnets      = ["10.238.11.0/24", "10.238.12.0/24", "10.238.13.0/24"]
  admin_subnets       = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]

  enable_nat_gateway    = true
  single_nat_gateway    = true

  tags = {
    Owner       = "Platform Engineering"
    Environment = "production"
    Name        = "project_name"
  }
}

# Create a file named output.tf and add:

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
```
