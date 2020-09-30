# Parameters

## Input

| Parameter | Default value | Description | Type  | Required | Example |
|-----------|---------------|-------------|-------|----------|---------|
| `source` | | Source of module | String | Yes | |
| region | `us-east-1` | AWS region where you want to create resources | String | No | |
| shared_credentials_file |`~/.aws/credentials` | AWS shared credentials file | String | No | |
| `name` | | Name for VPC resource, this is used for other commponents too | String | Yes | |
| profile | `default` | Credentials profile name used to create resources in AWS | String | No | |
| `cidr` | `0.0.0.0/0` | CIDR for the whole VPC | String | Yes | 172.17.0.0/16 |
| `public_subnets` | | Create Public subnet. This must be the same range as VPC CIDR | List | Yes | ["172.17.10.0/24","172.17.11.0/24"] |
| `private_subnets` | | Create Private subnet. This must be in the same range as VPC CIDR | List | Yes | ["172.17.20.0/24","172.17.21.0/24"] |
| `data_subnets` | | Create Data subnet. This must be in the same range as VPC CIDR | List | Yes | ["172.17.30.0/24","172.17.31.0/24"] |
| admin_subnets | | Create Admin subnet. This must be in the same range as VPC CIDR | List | No | ["172.17.40.0/24","172.17.41.0/24"] |
| `availability_zones` | | Create subnets in different AZ. This depends of AWS region | List | Yes | ["us-east-1d", "us-east-1e", "us-east-1f"] |
| enable_nat_gateway | `false` | Enable NAT Gateway for private network | Bool | No | |
| single_nat_gateway | `false` | Provision a single shared NAT Gateway across all of your private networks | Bool | No | |
| enable_vpn_gateway | `false` | Enable VPN Gateway attach it to the VPC | Bool | No | |
| tags | | Add tags to all VPC resources | Map | No | |
| vpc_tags | | Add tags for VPC resource | Map | No | |
| igw_tags | | Add tags for Internet Gateways resource | Map | No | |
| enable_dns_hostnames | `true` | Assign DNS name for IPs | Bool | No | |
| enable_dns_support | `true` | Enable DNS support | Bool | No | |
| secondary_cidr_blocks | | List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool | List | No | |
| assign_generated_ipv6_cidr_block | `false` | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block | Bool | No | |
| public_subnet_suffix | `subnet-public` | Suffix to append to public subnets name | String | No | |
| private_subnet_suffix | `subnet-private` | Suffix to append to private subnets name | String | No | |
| data_subnet_suffix | `subnet-data` | Suffix to append to private subnets name | String | No | |
| public_subnets_tags | | Add tags for public subnets | Map | No | |
| private_subnets_tags | | Add tags for private subnets | Map | No | |
| private_route_table_tags | |  Add tags for private route table | Map | No | |
| data_route_table_tags | |  Add tags for data route table | Map | No | |
| nat_gateway_tags | | Add tags for NAT Gateway | Map | No | |
| nat_eip_tags | | Add tags for NAT Elastic IP | Map | No | |
| map_public_ip_on_launch | `true` | Auto-assign public IP on launch | Bool | No | |
| one_nat_gateway_per_az | `false` | Enable NAT Gateway per availability zone | Bool | No | |
| propagate_private_route_tables_vgw | `false` | Enable private route table propagation | Bool | No | |
| propagate_public_route_tables_vgw | `false` | Enable public route table propagation | Bool | No | |
| vpn_gateway_id | | ID of VPN Gateway to attach to the VPC | String | No | |
| amazon_side_asn | `64512` | Autonomous System Number (ASN) for the Amazon side of the gateway | Number | No | |
| vpn_gateway_tags | | Add tags for VPN Gateway | Map | No | |
| create_admin_subnet_route_table | `false` | Separate route table for Admin subnet | Bool | No | |
| admin_route_table_tags | | Add tags for Admin route table | Map | No | |
| admin_subnet_suffix | | Suffix to append to Admin subnets name | String | No | |
| admin_subnets_tags | | Add tags for Admin subnets | Map | No | |
| create_admin_subnet_group | `true` | Controls if Admin subnet group should be created | Bool | No | |
| admin_subnet_group_tags | |  Add tags for Admin subnet group | Map | No | |
| logs_retention_in_days | `30` | Number of days you want to retain log events in the specified log group | Number | No | |
| traffic_type | `ALL` | The type of traffic to capture | String | No | ACCEPT, REJECT and ALL |
| dhcp_options_tags | | Additional tags for the DHCP option set (requires enable_dhcp_options set to true) | Map | No | |
| enable_dhcp_options | `false` | Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type | Bool | No | |
| dhcp_options_domain_name | | Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true) | String | No | |
| dhcp_options_domain_name_servers | `["AmazonProvidedDNS"]` | Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true) | List | No | |
| dhcp_options_ntp_servers | | Specify a list of NTP servers for DHCP options set (requires enable_dhcp_options set to true) | List | No | |
| dhcp_options_netbios_name_servers | | Specify a list of netbios servers for DHCP options set (requires enable_dhcp_options set to true) | List | No | |
| dhcp_options_netbios_node_type | | Specify netbios node_type for DHCP options set (requires enable_dhcp_options set to true) | String | No | |

## Output

| Parameter | Description   |
|-----------|---------------|
| module.vpc.vpc_name | Show VPN name |
| module.vpc.vpc_id | Show VPN ID |
| module.vpc.public_subnet_ids | Public subnet ID(s) |
| module.vpc.private_subnet_ids | Private subnet ID(s) |
| module.vpc.data_subnet_ids | Data subnet ID(s) |
| module.vpc.cidr_block | VPC CIDR bock |
| module.vpc.nat_gateway_ips | NAT gateway IP(s) |
| module.vpc.public_subnets | IP(s) of Public subnet |
| module.vpc.private_subnets | IP(s) of Private subnet |
| module.vpc.data_subnets | IP(s) of Data subnet |
| module.vpc.internet_gateway_id | Internet Gateway ID |
| module.vpc.nat_public_ips | NAT public IP(s) |
| module.vpc.admin_subnets | Admin subnet ID(s) |
| module.vpc.admin_subnets_cidr_blocks | List of CIDR blocks of Admin subnets |
| module.vpc.admin_subnet_group | ID(s) of Admin subnet group |
| module.vpc.admin_route_table_ids | List of ID(s) of admin route tables |
| module.vpc.public_route_table_ids | List of ID(s) of public route tables |
| module.vpc.private_route_table_ids | List of ID(s) of private route tables |
| module.vpc.data_route_table_ids | List of ID(s) of data route tables |
