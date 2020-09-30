output "vpc_name" {
  value = "${var.name}"
}

output "vpc_id" {
  value = "${aws_vpc.vpc.*.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnets.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnets.*.id}"]
}

output "data_subnet_ids" {
  value = ["${aws_subnet.data_subnets.*.id}"]
}

output "cidr_block" {
  value = "${var.cidr}"
}

output "nat_gateway_ips" {
  value = ["${aws_eip.public.*.public_ip}"]
}

output "public_subnets" {
  value = "${aws_subnet.public_subnets.*.cidr_block}"
}

output "private_subnets" {
  value = "${aws_subnet.private_subnets.*.cidr_block}"
}

output "data_subnets" {
  value = "${aws_subnet.data_subnets.*.cidr_block}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.gw.*.id}"
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${aws_eip.public.*.public_ip}"]
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = "${aws_route_table.public.*.id}"
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = "${aws_route_table.private.*.id}"
}

output "data_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = "${aws_route_table.data.*.id}"
}

# [admin] output
output "admin_subnets" {
  description = "List of IDs of admin subnets"
  value       = ["${aws_subnet.admin.*.id}"]
}

output "admin_subnets_cidr_blocks" {
  description = "List of cidr_blocks of admin subnets"
  value       = ["${aws_subnet.admin.*.cidr_block}"]
}

output "admin_route_table_ids" {
  description = "List of IDs of admin route tables"
  value       = ["${coalesce(aws_route_table.admin.*.id, aws_route_table.private.*.id)}"]
}
