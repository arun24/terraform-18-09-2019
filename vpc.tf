# VPC for our applications
    resource "aws_vpc" "arun_vpc" {
    cidr_block       = "${var.vpc_cidr}"
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
    count = "${length(var.subnets_cidr)}"
    vpc_id     = "${aws_vpc.arun_vpc.id}"
    availability_zone = "${element(var.azs, count.index)}"
  cidr_block = "${element(var.subnets_cidr, count.index)}"

  tags = {
    Name = "subnet-${count.index + 1}"
  }
  
}

  


