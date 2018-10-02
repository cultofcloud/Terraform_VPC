# Virtual Private Cloud
resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_block}"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags {
    Name = "${var.vpc_name}"
  }
}

# =============================================

# Public Subnets

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.vpc_cidr_pub_sub[count.index]}"
  availability_zone = "${element(split(",", lookup(var.vpc_azs, var.AWS_REGION)), count.index)}"
  count             = "${length(split(",", lookup(var.vpc_azs, var.AWS_REGION)))}"

  tags {
    Name = "${var.env}-pub-${element(split(",", lookup(var.vpc_azs, var.AWS_REGION)), count.index)}"
  }
}

# =============================================

# Private Subnets

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.vpc_cidr_priv_sub[count.index]}"
  availability_zone = "${element(split(",", lookup(var.vpc_azs, var.AWS_REGION)), count.index)}"
  count             = "${length(split(",", lookup(var.vpc_azs, var.AWS_REGION)))}"

  tags {
    Name = "${var.env}-priv-${element(split(",", lookup(var.vpc_azs, var.AWS_REGION)), count.index)}"
  }
}

# =============================================

# Data Subnets

resource "aws_subnet" "data" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.vpc_cidr_data_sub[count.index]}"
  availability_zone = "${element(split(",", lookup(var.vpc_azs, var.AWS_REGION)), count.index)}"
  count             = "${length(split(",", lookup(var.vpc_azs, var.AWS_REGION)))}"

  tags {
    Name = "${var.env}-data-${element(split(",", lookup(var.vpc_azs, var.AWS_REGION)), count.index)}"
  }
}

# =============================================

# Application Subnets

resource "aws_subnet" "app" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.vpc_cidr_app_sub[count.index]}"
  availability_zone = "${element(split(",", lookup(var.vpc_azs, var.AWS_REGION)), count.index)}"
  count             = "${length(split(",", lookup(var.vpc_azs, var.AWS_REGION)))}"

  tags {
    Name = "${var.env}-app-${element(split(",", lookup(var.vpc_azs, var.AWS_REGION)), count.index)}"
  }
}

# =================================================

# Internet GW
resource "aws_internet_gateway" "inet-gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.env}-inet-gw"
  }
}

# ==================================================

# Route Tables

resource "aws_route_table" "default-pub-route-table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.inet-gw.id}"
  }

  tags {
    Name = "default-pub-route-table"
  }
}

# Route Associations for Public Subnets
resource "aws_route_table_association" "route-pub-2a" {
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.default-pub-route-table.id}"
  count          = "${length(split(",", lookup(var.vpc_azs, var.AWS_REGION)))}"
}
