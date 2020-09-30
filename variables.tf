variable "region" {
  description = "Region you want to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "shared_credentials_file" {
  description = "File that contains AWS credentials"
  type        = string
  default     = "~/.aws/credentials"
}

variable "profile" {
  description = "Specify the profile to apply write AWS credentials"
  type        = string
  default     = "default"
}

variable "create_vpc" {
  description = "Enable creating VPC"
  type        = bool
  default     = true
}

variable "name" {
  description = "Give a VPC name"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = "Additional tags for the internet gateway"
  type        = map(string)
  default     = {}
}

variable "enable_dns_hostnames" {
  description = "Should be true if you want to assign dns name for IPs"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
    description = "Should be true if you want to DNS support"
    type        = bool
    default     = true
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool"
  type        = list(string)
  default     = [] # Ex. 172.17.0.0/16 (172.17.0.0 to 172.17.255.255)
}

variable "public_subnets" {
  description = "CIDR list for the Public Subnet"
  type        = list(string)
  default     = [] # Ex. ["172.17.10.0/24","172.17.11.0/24"] (172.17.1.0 to 172.17.1.255)
}

variable "private_subnets" {
  description = "CIDR list for the Private Subnet"
  type        = list(string)
  default     = [] # E.g. ["172.17.20.0/24","172.17.21.0/24","172.17.22.0/24","172.17.23.0/24"] (172.17.1.0 to 172.17.1.255)
}

variable "data_subnets" {
  description = "CIDR list for the Data Subnet"
  type        = list(string)
  default     = [] # E.g. ["172.17.30.0/24","172.17.31.0/24","172.17.32.0/24","172.17."3.0/24"] (172.17.1.0 to 172.17.1.255)
}


variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block"
  type        = bool
  default     = false
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "subnet-public"
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "subnet-private"
}

variable "data_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "subnet-data"
}

variable "public_route_table_suffix" {
  description = "Suffix to append to public route tables name"
  type        = string
  default     = "route-table-public"
}

variable "private_route_table_suffix" {
  description = "Suffix to append to private route tables name"
  type        = string
  default     = "route-table-private"
}

variable "data_route_table_suffix" {
  description = "Suffix to append to data route tables name"
  type        = string
  default     = "route-table-data"
}

variable "public_subnets_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "public_route_table_tags" {
  description = "Additional tags for the public route tables"
  type        = map(string)
  default     = {}
}

variable "private_subnets_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route tables"
  type        = map(string)
  default     = {}
}

variable "data_subnets_tags" {
  description = "Additional tags for the data subnets"
  type        = map(string)
  default     = {}
}

variable "data_route_table_tags" {
  description = "Additional tags for the data route tables"
  type        = map(string)
  default     = {}
}

variable "nat_gateway_tags" {
  description = "Additional tags for the NAT gateways"
  type        = map(string)
  default     = {}
}

variable "nat_eip_tags" {
  description = "Additional tags for the NAT EIP"
  type        = map(string)
  default     = {}
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = true
}

variable "availability_zones" {
  description = "Give a list with availability zones"
  type        = list(string)
  default     = []
}

variable "enable_deletion_protection" {
  description = "Should be true if you want protection for deletion"
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.availability_zones` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.availability_zones`"
  type        = bool
  default     = false
}

// VPN Gateway
variable "enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  type        = bool
  default     = false
}

variable "propagate_private_route_tables_vgw" {
  description = "Should be true if you want route table propagation"
  type        = bool
  default     = false
}

variable "propagate_public_route_tables_vgw" {
  description = "Should be true if you want route table propagation"
  type        = bool
  default     = false
}

variable "vpn_gateway_id" {
  description = "ID of VPN Gateway to attach to the VPC"
  type        = string
  default     = ""
}

variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the virtual private gateway is created with the current default Amazon ASN."
  type        = string
  default     = "64512"
}

variable "vpn_gateway_tags" {
  description = "Additional tags for the VPN gateway"
  type        = map(string)
  default     = {}
}

variable "admin_subnets" {
  description = "CIDR list for the Admin network"
  type        = list(string)
  default     = []
}

variable "create_admin_subnet_route_table" {
  description = "Should be true if you want to separate route table for admin"
  type        = bool
  default     = false
}

variable "admin_route_table_tags" {
  description = "Additional tags for the admin route tables"
  type        = map(string)
  default     = {}
}

variable "admin_subnet_suffix" {
  description = "Suffix to append to admin subnets name"
  type        = string
  default     = "subnet-admin"
}

variable "admin_route_table_suffix" {
  description = "Suffix to append to admin subnets name"
  type        = string
  default     = "route-table-admin"
}

variable "admin_subnets_tags" {
  description = "Additional tags for the admin subnets"
  type        = map(string)
  default     = {}
}

variable "create_admin_subnet_group" {
  description = "Controls if admin subnet group should be created"
  type        = bool
  default     = true
}

variable "admin_subnet_group_tags" {
  description = "Additional tags for the admin subnet group"
  type        = map(string)
  default     = {}
}

variable "logs_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 30
}

variable "traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT and ALL"
  type        = string
  default     = "ALL"
}

// DHCP variables
variable "dhcp_options_tags" {
  description = "Additional tags for the DHCP option set (requires enable_dhcp_options set to true)"
  type        = map(string)
  default     = {}
}

variable "enable_dhcp_options" {
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type"
  type        = bool
  default     = false
}

variable "dhcp_options_domain_name" {
  description = "Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = "Specify a list of NTP servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = "Specify a list of netbios servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = "Specify netbios node_type for DHCP options set (requires enable_dhcp_options set to true)"
  type        = number
  default     = 2
}

variable "data_network_acl_suffix" {
  description = "Suffix to append to data network acl name"
  type        = string
  default     = "network-acl-data"
}
