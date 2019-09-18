# VPC for our applications
resource "aws_vpc" "arun_vpc" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
    Name = "Arunvpc"
  }
}
# create Internet Gatway attach it to arun_vpc
resource "aws_internet_gateway" "arun_igw" {
  vpc_id = "${aws_vpc.arun_vpc.id}"
  tags = {
    Name = "main"
  }
}
#Build subnets for our VPCs
resource "aws_subnet" "public" {
  count             = "${length(var.subnets_cidr)}"
  vpc_id            = "${aws_vpc.arun_vpc.id}"
  availability_zone = "${element(var.azs, count.index)}"
  cidr_block        = "${element(var.subnets_cidr, count.index)}"

  tags = {
    Name = "subnet-${count.index + 1}"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.arun_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.arun_igw.id}"
  }
  tags = {
    Name = "Public-rt"
  }
}
#Attach route table with public subnets
resource "aws_route_table_association" "a" {
  count          = "${length(var.subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}




