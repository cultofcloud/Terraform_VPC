# NAT Gateway

resource "aws_eip" "nat" {
  vpc   = true
  count = "${length(split(",", lookup(var.vpc_azs, var.AWS_REGION)))}"
}

resource "aws_nat_gateway" "nat-gw-public" {
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  count         = "${length(split(",", lookup(var.vpc_azs, var.AWS_REGION)))}"
  depends_on    = ["aws_internet_gateway.inet-gw"]
}

# ===============================================================================
# Route Table for Private

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat-gw-public.*.id, count.index)}"
  }
  count = "${length(split(",", lookup(var.vpc_azs, var.AWS_REGION)))}"

  tags {
    Name = "${var.env}-default-priv-route-${element(split(",", lookup(var.vpc_azs, var.AWS_REGION)), count.index)}"
  }
}

# ================================================================
# Route Associations Private Subnets

resource "aws_route_table_association" "private" {
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  count          = "${length(split(",", lookup(var.vpc_azs, var.AWS_REGION)))}"
}

# ================================================================
# Route Associations Data Subnets

resource "aws_route_table_association" "data" {
  subnet_id      = "${element(aws_subnet.data.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  count          = "${length(split(",", lookup(var.vpc_azs, var.AWS_REGION)))}"
}

# ================================================================
# Route Associations App Subnets

resource "aws_route_table_association" "app" {
  subnet_id      = "${element(aws_subnet.app.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  count          = "${length(split(",", lookup(var.vpc_azs, var.AWS_REGION)))}"
}