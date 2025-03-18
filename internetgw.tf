resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "main-gateway"
    Environment = "dev"
  }
}
