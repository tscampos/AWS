resource "aws_internet_gateway" "aws-igw" {
  vpc_id = aws_vpc.aws-vpc.id
  
  tags = {
    Name        = "${var.app_name}-igw"
    Environment = var.app_environment
  }

}
# Cria sub-rede privada
## Contabiliza e sincroniza "faixa" de IP com zona disponível (1ª= 10.10.0.0/24 | 2ª= 10.10.1.0/24) && (1ª= us-east-1a" | 2ª="us-east-1b")
# resource "aws_subnet" "private" {
#   vpc_id            = aws_vpc.aws-vpc.id
#   count             = length(var.private_subnets)
#   cidr_block        = element(var.private_subnets, count.index)
#   availability_zone = element(var.availability_zones, count.index)

#   tags = {
#     Name        = "${var.app_name}-private-subnet-${count.index + 1}" # [1] Minhaaplicação-private-subnet-10.10.0.0/24 | [2] {...}-10.10.1.0/24
#     Environment = var.app_environment
#   }
# }

# Cria sub-rede privada
## Contabiliza e sincroniza "faixa" de IP com zona disponível {...}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-public-subnet-${count.index + 1}"
    Environment = var.app_environment
  }
}

# Libera rota para acesso à internet através do Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.aws-vpc.id

  tags = {
    Name        = "${var.app_name}-routing-table-public"
    Environment = var.app_environment
  }
}

# Define as configurações da rota a ser utilizada
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws-igw.id
}

# Faz a devida associação da rota com a faixa de IP's
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}