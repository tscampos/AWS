resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MY_igw"
  }
}

# Criação da sub-rede privada
resource "aws_subnet" "my_private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24" 
  availability_zone       = "us-east-1a"            

  tags = {
    Name = "MY_private-subnet"
  }
}

# Criação da sub-rede pública
resource "aws_subnet" "my_public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"  
  availability_zone       = "us-east-1a"   
  map_public_ip_on_launch = true           

  tags = {
    Name = "MY_public-subnet"
  }
}


# Criação da tabela de roteamento
resource "aws_route_table" "my_route_table_public" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MY-route-table"
  }
}

# Criação da rota padrão para acesso à internet
resource "aws_route" "my_route_public" {
  route_table_id         = aws_route_table.my_route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id 
}

# Criação da associação da tabela de roteamento com a sub-rede
resource "aws_route_table_association" "my_route_table_association_public" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_route_table_public.id
}