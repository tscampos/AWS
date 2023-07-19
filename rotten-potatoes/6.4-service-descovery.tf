# Criação do namespace no Amazon ECS
resource "aws_service_discovery_private_dns_namespace" "ecs_namespace" {
  name        = "${var.app_name}-${var.app_environment}-namespace"
  vpc         = aws_vpc.aws-vpc.id
  description = "Private DNS namespace for ECS"
}

# Criação do serviço no Cloud Map para a primeira Task Definition
resource "aws_service_discovery_service" "service1" {
  name             = "${var.app_name}-service1"
  namespace_id     = aws_service_discovery_private_dns_namespace.ecs_namespace.id

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs_namespace.id

    dns_records {
      type = "A"
      ttl  = 300
    }
  }
}

# Criação do serviço no Cloud Map para a segunda Task Definition
resource "aws_service_discovery_service" "service2" {
  name             = "${var.app_name}-service2"
  namespace_id     = aws_service_discovery_private_dns_namespace.ecs_namespace.id

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs_namespace.id

    dns_records {
      type = "A"
      ttl  = 300
    }
  }
}
































# # Criação de um Service Discovery para um serviço específico
# resource "aws_service_discovery_service" "rotten_potatoes_descovery" {
#   name         = "api-service"
#   namespace_id = aws_service_discovery_private_dns_namespace.ecs_namespace.id

#   dns_config {
#     namespace_id = aws_service_discovery_private_dns_namespace.ecs_namespace.id

#     dns_records {
#       type = "A"
#       ttl  = 300
#     }
#   }
# }

# # Criação de um Service Discovery para outro serviço
# resource "aws_service_discovery_service" "mongodb_service_discovery" {
#   name         = "mongo-service"
#   namespace_id = aws_service_discovery_private_dns_namespace.ecs_namespace.id

#   dns_config {
#     namespace_id = aws_service_discovery_private_dns_namespace.ecs_namespace.id

#     dns_records {
#       type = "A"
#       ttl  = 300
#     }
#   }
# }

