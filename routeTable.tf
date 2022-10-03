resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.TrainingVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "publicRouteTable"
  }
}

resource "aws_route_table_association" "PublicAssociationA" {
  subnet_id      = aws_subnet.publicSubnetA.id
  route_table_id = aws_route_table.publicRouteTable.id
}

resource "aws_route_table_association" "PublicAssociationB" {
  subnet_id      = aws_subnet.publicSubnetB.id
  route_table_id = aws_route_table.publicRouteTable.id
}

resource "aws_route_table" "privateRouteTable" {
  vpc_id = aws_vpc.TrainingVPC.id


  tags = {
    Name = "privateRouteTable"
  }
}

resource "aws_route_table_association" "PrivateAssociationA" {
  subnet_id      = aws_subnet.privateSubnetA.id
  route_table_id = aws_route_table.privateRouteTable.id
}

resource "aws_route_table_association" "PrivateAssociationB" {
  subnet_id      = aws_subnet.privateSubnetB.id
  route_table_id = aws_route_table.privateRouteTable.id
}

