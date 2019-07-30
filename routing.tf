##NETWORKING COMPONENTS FOR MODERNIZATION TEMPLATES - ROUTING TABLES & ASSIGNMENTS

#public routing
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.hulk.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

   route {
    cidr_block = "10.2.0.0/16"
    vpc_peering_connection_id = "pcx-08e60001czzzzzzzz"
  }

   route {
    cidr_block = "192.168.0.0/16"
    vpc_peering_connection_id = "pcx-0f56a25c7zzzzzzzz"
  }

  tags {
    Name = "Public Subnet RT"
  }
}

##associate the public route table with public subnets
resource "aws_route_table_association" "web-public-rt1" {
  subnet_id = "${aws_subnet.public-subnet1.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

resource "aws_route_table_association" "web-public-rt2" {
  subnet_id = "${aws_subnet.public-subnet2.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

resource "aws_route_table_association" "web-public-rt3" {
  subnet_id = "${aws_subnet.public-subnet3.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

#NAT gateway routing

resource "aws_route_table" "NAT1" {
  vpc_id = "${aws_vpc.hulk.id}"

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat1.id}" 
  }

  tags {
    name = "Private RT1"
  } 
}

resource "aws_route_table_association" "private-subnet1" {
  subnet_id = "${aws_subnet.private-subnet1.id}"
  route_table_id = "${aws_route_table.NAT1.id}"
  
}

resource "aws_route_table" "NAT2" {
  vpc_id = "${aws_vpc.hulk.id}"

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat2.id}" 
  }

  tags {
    name = "Private RT2"
  } 
}

resource "aws_route_table_association" "private-subnet2" {
  subnet_id = "${aws_subnet.private-subnet2.id}"
  route_table_id = "${aws_route_table.NAT2.id}"
  
}


resource "aws_route_table" "NAT3" {
  vpc_id = "${aws_vpc.hulk.id}"

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat3.id}" 
  }

  tags {
    name = "Private RT3"
  } 
}

resource "aws_route_table_association" "private-subnet3" {
  subnet_id = "${aws_subnet.private-subnet3.id}"
  route_table_id = "${aws_route_table.NAT3.id}"
  
}