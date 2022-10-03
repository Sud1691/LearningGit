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