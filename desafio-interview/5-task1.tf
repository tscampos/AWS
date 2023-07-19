# resource "aws_ecs_task_definition" "mongodb_task" {
#   family                   = "mongodb-task"
#   execution_role_arn       = aws_iam_role.task_execution_role.arn
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]

#   container_definitions = <<DEFINITION
#   [
#     {
#       "name": "mongodb-container",
#       "image": "public.ecr.aws/docker/library/mongo:latest",
#       "portMappings": [
#         {
#           "containerPort": 27017,
#           "protocol": "tcp"
#         }
#       ],
#       "memory": 512,
#       "cpu": 256,
#       "logConfiguration": {
#         "logDriver": "awslogs",
#         "options": {
#           "awslogs-group": "/ecs/mongodb-task",
#           "awslogs-region": "us-east-1",
#           "awslogs-stream-prefix": "mongodb-container"
#         }
#       },
#       "environment": [
#         {
#           "name": "MONGO_INITDB_ROOT_USERNAME",
#           "value": "mongousr"
#         },
#         {
#           "name": "MONGO_INITDB_ROOT_PASSWORD",
#           "value": "mongopwd"
#         }
#       ]
#     }
#   ]
#   DEFINITION

#   tags = {
#     Name        = "mongodb-task"
#     Environment = "Production"
#   }
# }
