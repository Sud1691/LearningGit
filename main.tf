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
    Name = var.instance_name
  }
}

resource "aws_eip" "TrainingEIPA" {
  vpc = true

}

resource "aws_eip" "TrainingEIPB" {
  vpc = true

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.TrainingVPC.id

  tags = {
    Name = var.igw
  }
}

resource "aws_nat_gateway" "TrainingNGWA" {
  allocation_id = aws_eip.TrainingEIPA.id
  subnet_id     = aws_subnet.publicSubnetA.id

  tags = {
    Name = var.ngw
  }

}

resource "aws_nat_gateway" "TrainingNGWB" {
  allocation_id = aws_eip.TrainingEIPB.id
  subnet_id     = aws_subnet.publicSubnetB.id

  tags = {
    Name = var.ngw
  }
}

resource "aws_route_table" "publicRouteTableA" {
  vpc_id = aws_vpc.TrainingVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.publicRouteTable
  }
}

resource "aws_route_table_association" "PublicAssociationA" {
  subnet_id      = aws_subnet.publicSubnetA.id
  route_table_id = aws_route_table.publicRouteTableA.id
}

resource "aws_route_table_association" "PublicAssociationB" {
  subnet_id      = aws_subnet.publicSubnetB.id
  route_table_id = aws_route_table.publicRouteTableA.id
}


resource "aws_route_table" "privateRouteTableA" {
  vpc_id = aws_vpc.TrainingVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.TrainingNGWA.id
  }

  tags = {
    Name = var.privateRouteTable
  }
}

resource "aws_route_table" "privateRouteTableB" {
  vpc_id = aws_vpc.TrainingVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.TrainingNGWB.id
  }

  tags = {
    Name = var.privateRouteTable
  }
}

resource "aws_route_table_association" "PrivateAssociationA" {
  subnet_id      = aws_subnet.privateSubnetA.id
  route_table_id = aws_route_table.privateRouteTableA.id
}

resource "aws_route_table_association" "PrivateAssociationB" {
  subnet_id      = aws_subnet.privateSubnetB.id
  route_table_id = aws_route_table.privateRouteTableB.id
}

resource "aws_subnet" "publicSubnetA" {
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = var.Public_subnet
  }
}

resource "aws_subnet" "publicSubnetB" {
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = var.Public_subnet
  }
}

resource "aws_subnet" "privateSubnetA" {
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = var.Private_subnet
  }
}

resource "aws_subnet" "privateSubnetB" {
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = var.Private_subnet
  }
}

resource "aws_vpc" "TrainingVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

