#resource "aws_vpc" "main" {
#  cidr_block = "10.0.0.0/16"
#}
#
#resource "aws_internet_gateway" "main" {
#  vpc_id = aws_vpc.main.id
#}
#
#resource "aws_route_table" "public" {
#  vpc_id = aws_vpc.main.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.main.id
#  }
#}
#
#resource "aws_subnet" "public_1a" {
#  vpc_id            = aws_vpc.main.id
#  availability_zone = "ap-northeast-1a"
#  cidr_block        = "10.0.0.0/24"
#}
#
#resource "aws_subnet" "public_1c" {
#  vpc_id            = aws_vpc.main.id
#  availability_zone = "ap-northeast-1c"
#  cidr_block        = "10.0.1.0/24"
#}
#
#resource "aws_route_table_association" "public_1a" {
#  subnet_id      = aws_subnet.public_1a.id
#  route_table_id = aws_route_table.public.id
#}
#
#resource "aws_route_table_association" "public_1c" {
#  subnet_id      = aws_subnet.public_1c.id
#  route_table_id = aws_route_table.public.id
#}
