resource "aws_subnet" "publicSubnetA" {
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "publicSubnetA"
  }
}

resource "aws_subnet" "publicSubnetB" {
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "publicSubnetB"
  }
}

resource "aws_subnet" "privateSubnetA" {
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = "10.0.2.0/20"

  tags = {
    Name = "privateSubnetA"
  }
}

resource "aws_subnet" "privateSubnetB" {
  vpc_id     = aws_vpc.TrainingVPC.id
  cidr_block = "10.0.3.0/20"

  tags = {
    Name = "privateSubnetB"
  }
}