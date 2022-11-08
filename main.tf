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

resource "aws_eip" "TrainingEIP" {
  count = length(var.elastic_ip)
  vpc = true


  tags = {
    Name = var.elastic_ip[count.index]
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.TrainingVPC.id

  tags = {
    Name = var.igw
  }
}

resource "aws_nat_gateway" "TrainingNGW" {
  count = length(var.ngw)
  allocation_id = aws_eip.TrainingEIP[count.index].id
  subnet_id     = aws_subnet.publicSubnet[count.index].id

  tags = {
    Name = var.ngw[count.index]
  }

}

resource "aws_route_table" "publicRouteTable" {
  vpc_id = aws_vpc.TrainingVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.publicRouteTable
  }
}

resource "aws_route_table_association" "PublicAssociation" {
  count = length(var.Public_subnet)
  subnet_id      = aws_subnet.publicSubnet[count.index].id
  route_table_id = aws_route_table.publicRouteTable.id
}


resource "aws_route_table" "privateRouteTable" {
  count = length(var.privateRouteTable)
  vpc_id = aws_vpc.TrainingVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.TrainingNGW[count.index].id
  }

  tags = {
    Name = var.privateRouteTable[count.index]
  }
}

resource "aws_route_table_association" "PrivateAssociation" {
  count = length(var.Private_subnet)
  subnet_id      = aws_subnet.privateSubnet[count.index].id
  route_table_id = aws_route_table.privateRouteTable[count.index].id
}


resource "aws_subnet" "publicSubnet" {
  count = length(var.Public_subnet)
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = var.Public_subnet_cidr[count.index]

  tags = {
    Name = var.Public_subnet[count.index]
  }
}

resource "aws_subnet" "privateSubnet" {
  count = length(var.Private_subnet)
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = var.Private_subnet_cidr[count.index]

  tags = {
    Name = var.Private_subnet[count.index]
  }
}

resource "aws_vpc" "TrainingVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

hi kritika