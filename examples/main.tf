# Example creating VPC
module "vpc" {
  source = "../"

  name    = "terraform_vpc_example"
  region  = "eu-west-1"
  profile = "rd"

  cidr   = "10.236.0.0/16"

  availability_zones  = ["eu-west-1a", "eu-west-1b"]
  private_subnets     = ["10.236.1.0/24", "10.236.2.0/24"]
  public_subnets      = ["10.236.11.0/24", "10.236.12.0/24"]
  # admin_subnets       = ["10.236.21.0/24", "10.236.22.0/24"]

  enable_nat_gateway    = true
  single_nat_gateway    = true

  # Custom DHCP
  enable_dhcp_options = true
  dhcp_options_domain_name = "sub.domain.net"

  tags = {
    Owner       = "Marius Stanca"
    Environment = "testing"
    Name        = "terraform-vpc-example"
    Managed     = "Terraform"
    Project     = "project_name"
  }
}
