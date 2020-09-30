// VPC module
// Maintainer Marius Stanca <me@marius.xyz>

locals {
  vpc_id            = element(concat(aws_vpc_ipv4_cidr_block_association.this.*.vpc_id, aws_vpc.vpc.*.id, list("")), 0)
  max_subnet_length = max(length(var.private_subnets), length(var.admin_subnets))
  nat_gateway_count = var.single_nat_gateway ? 1 : (var.one_nat_gateway_per_az ? length(var.availability_zones) : local.max_subnet_length)
}

resource "aws_vpc" "vpc" {
  count = var.create_vpc ? 1 : 0

  cidr_block                       = var.cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = merge(map("Name", format("%s-vpc-%s", var.name, var.region)), var.tags, var.vpc_tags)
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = var.create_vpc && length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0

  vpc_id = join("", aws_vpc.vpc.*.id)

  cidr_block = element(var.secondary_cidr_blocks, count.index)
}

// DHCP Options Set
resource "aws_vpc_dhcp_options" "this" {
  count = var.create_vpc && var.enable_dhcp_options ? 1 : 0

  domain_name          = var.dhcp_options_domain_name
  domain_name_servers  = var.dhcp_options_domain_name_servers
  ntp_servers          = var.dhcp_options_ntp_servers
  netbios_name_servers = var.dhcp_options_netbios_name_servers
  netbios_node_type    = var.dhcp_options_netbios_node_type

  tags = merge(map("Name", format("%s", var.name)), var.tags, var.public_subnets_tags)
}

// DHCP Options Set Association
resource "aws_vpc_dhcp_options_association" "this" {
  count = var.create_vpc && var.enable_dhcp_options ? 1 : 0

  vpc_id          = local.vpc_id
  dhcp_options_id = join("", aws_vpc_dhcp_options.this.*.id)
}

// Public subnet
resource "aws_subnet" "public_subnets" {
  count = var.create_vpc && length(var.public_subnets) > 0 && (false == var.one_nat_gateway_per_az || length(var.public_subnets) >= length(var.availability_zones)) ? length(var.public_subnets) : 0

  vpc_id                  = local.vpc_id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(map("Name", format("%s-${var.public_subnet_suffix}-%s", var.name, element(var.availability_zones, count.index))), var.tags, var.public_subnets_tags)
}

// Private subnet
resource "aws_subnet" "private_subnets" {
  count = var.create_vpc && length(var.private_subnets) > 0 && (length(var.private_subnets) >= length(var.availability_zones)) ? length(var.private_subnets) : 0

  vpc_id            = local.vpc_id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(map("Name", format("%s-${var.private_subnet_suffix}-%s", var.name, element(var.availability_zones, count.index))), var.tags, var.private_subnets_tags)
}

// Data subnet
resource "aws_subnet" "data_subnets" {
  count = var.create_vpc && length(var.data_subnets) > 0 && (length(var.data_subnets) >= length(var.availability_zones)) ? length(var.data_subnets) : 0

  vpc_id            = local.vpc_id
  cidr_block        = element(var.data_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(map("Name", format("%s-${var.data_subnet_suffix}-%s", var.name, element(var.availability_zones, count.index))), var.tags, var.data_subnets_tags)
}

// Internet Gateway
resource "aws_internet_gateway" "gw" {
  count  = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(map("Name", format("%s-internet-gateway-%s", var.name, var.region)), var.tags, var.igw_tags)
}

// NAT Gateway
resource "aws_nat_gateway" "nat" {
  count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = element(aws_eip.public.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnets.*.id, count.index)
  tags          = merge(map("Name", format("%s-nat-gateway-%s", var.name, element(var.availability_zones, (var.single_nat_gateway ? 0 : count.index)))), var.tags, var.nat_gateway_tags)
  depends_on    = [aws_internet_gateway.gw]
}

// Associate EIP to Internet Gateway
resource "aws_eip" "public" {
  count      = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0
  vpc        = true
  tags       = merge(map("Name", format("%s-eip-nat-%s", var.name, element(var.availability_zones, (var.single_nat_gateway ? 0 : count.index)))), var.tags, var.nat_eip_tags)
  depends_on = [aws_internet_gateway.gw]
}

// Public route
resource "aws_route_table" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = local.vpc_id

  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.gw.id
  # }

  tags = merge(map("Name", format("%s-${var.public_route_table_suffix}", var.name)), var.tags, var.public_route_table_tags)
}

resource "aws_route" "public_internet_gateway" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = join("", aws_route_table.public.*.id)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = join("", aws_internet_gateway.gw.*.id)

  timeouts {
    create = "5m"
  }
}

// Private route
resource "aws_route_table" "private" {
  vpc_id = local.vpc_id
  count  = var.create_vpc && local.max_subnet_length > 0 ? local.nat_gateway_count : 0

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  tags = merge(map("Name", (var.single_nat_gateway ? "${var.name}-${var.private_route_table_suffix}" : format("%s-${var.private_route_table_suffix}-%s", var.name, element(var.availability_zones, count.index)))), var.tags, var.private_route_table_tags)
}

// Route associations
resource "aws_route_table_association" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = join("", aws_route_table.public.*.id)
}

resource "aws_route_table_association" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

// Data route
resource "aws_route_table" "data" {
  vpc_id = local.vpc_id

  tags = merge(map("Name", "${var.name}-${var.data_route_table_suffix}"), var.tags, var.data_route_table_tags)
}

// VPN Gateway
resource "aws_vpn_gateway" "this" {
  count = var.create_vpc && var.enable_vpn_gateway ? 1 : 0

  vpc_id          = local.vpc_id
  amazon_side_asn = var.amazon_side_asn

  tags = merge(map("Name", format("%s-vpn-gateway-%s", var.name, var.region)), var.tags, var.vpn_gateway_tags)
}

resource "aws_vpn_gateway_attachment" "this" {
  count = var.vpn_gateway_id != "" ? 1 : 0

  vpc_id         = local.vpc_id
  vpn_gateway_id = var.vpn_gateway_id
}

resource "aws_vpn_gateway_route_propagation" "public" {
  count = var.create_vpc && var.propagate_public_route_tables_vgw && (var.enable_vpn_gateway || var.vpn_gateway_id != "") ? 1 : 0

  route_table_id = element(aws_route_table.public.*.id, count.index)
  vpn_gateway_id = element(concat(aws_vpn_gateway.this.*.id, aws_vpn_gateway_attachment.this.*.vpn_gateway_id), count.index)
}

resource "aws_vpn_gateway_route_propagation" "private" {
  count = var.create_vpc && var.propagate_private_route_tables_vgw && (var.enable_vpn_gateway || var.vpn_gateway_id != "") ? length(var.private_subnets) : 0

  route_table_id = element(aws_route_table.private.*.id, count.index)
  vpn_gateway_id = element(concat(aws_vpn_gateway.this.*.id, aws_vpn_gateway_attachment.this.*.vpn_gateway_id), count.index)
}

// Add new subnet - admin
// Route table
resource "aws_route_table" "admin" {
  count  = var.create_vpc && var.create_admin_subnet_route_table && length(var.admin_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(var.tags, var.admin_route_table_tags, map("Name", "${var.name}-${var.admin_route_table_suffix}"))
}

// Subnet
resource "aws_subnet" "admin" {
  count = var.create_vpc && length(var.admin_subnets) > 0 ? length(var.admin_subnets) : 0

  vpc_id            = local.vpc_id
  cidr_block        = var.admin_subnets[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(map("Name", format("%s-${var.admin_subnet_suffix}-%s", var.name, element(var.availability_zones, count.index))), var.tags, var.admin_subnets_tags)
}

// Table association
resource "aws_route_table_association" "admin" {
  count = var.create_vpc && length(var.admin_subnets) > 0 ? length(var.admin_subnets) : 0

  subnet_id      = element(aws_subnet.admin.*.id, count.index)
  route_table_id = element(coalescelist(aws_route_table.admin.*.id, aws_route_table.private.*.id), (var.single_nat_gateway || var.create_admin_subnet_route_table ? 0 : count.index))
}

// ACL for admin subnet
resource "aws_network_acl" "data" {
  count = length(var.data_subnets) > 0 ? 1 : 0

  vpc_id     = element(aws_vpc.vpc.*.id, count.index)
  subnet_ids = aws_subnet.data_subnets.*.id

  tags = merge(map("Name", format("%s-${var.data_network_acl_suffix}", var.name)), var.tags, var.admin_subnets_tags)
}

//Inbound from private subnets
resource "aws_network_acl_rule" "private_inbound" {
  count = length(var.data_subnets) > 0 ? length(aws_subnet.private_subnets) : 0

  network_acl_id = aws_network_acl.data.0.id
  rule_number    = 100 + count.index
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = element(aws_subnet.private_subnets.*.cidr_block, count.index)
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "private_outbound" {
  count = length(var.data_subnets) > 0 ? length(aws_subnet.private_subnets) : 0

  network_acl_id = aws_network_acl.data.0.id
  rule_number    = 100 + count.index
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = element(aws_subnet.private_subnets.*.cidr_block, count.index)
  from_port      = 0
  to_port        = 0
}
