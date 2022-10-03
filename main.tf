terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}


resource "aws_eip" "TrainingEIP" {
  vpc              = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.TrainingVPC.id

  tags = {
    Name = "TrainingIGW"
  }
}

resource "aws_nat_gateway" "TrainingNGW" {
  allocation_id = aws_eip.TrainingEIP.id
  subnet_id     = aws_subnet.publicSubnetA.id

  tags = {
    Name = "TrainingNGWA"
  }

}

resource "aws_nat_gateway" "TrainingNGW" {
  allocation_id = aws_eip.TrainingEIP.id
  subnet_id     = aws_subnet.publicSubnetB.id

  tags = {
    Name = "TrainingNGWB"
  }

}

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

resource "aws_subnet" "publicSubnetA" {
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "publicSubnetA"
  }
}

resource "aws_subnet" "publicSubnetB" {
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "publicSubnetB"
  }
}

resource "aws_subnet" "privateSubnetA" {
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "privateSubnetA"
  }
}

resource "aws_subnet" "privateSubnetB" {
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "privateSubnetB"
  }
}

resource "aws_vpc" "TrainingVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "TrainingVPC"
  }
}

