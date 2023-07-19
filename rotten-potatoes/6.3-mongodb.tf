# Definição de tarefa para o contêiner do MongoDB
resource "aws_ecs_task_definition" "mongodb_task" {
  family                   = "mongodb_task"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"

  container_definitions = jsonencode([
    {
      "name" : "${var.app_name}-service2",
      "image" : "mongo:4.2.8",
      "environment" : [
        { "name" : "MONGO_INITDB_ROOT_USERNAME", "value" : "mongodbuser" },
        { "name" : "MONGO_INITDB_ROOT_PASSWORD", "value" : "mongodbpwd" }
      ],
      "essential" : true,
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.log-group.id,
          "awslogs-region" : var.aws_region,
          "awslogs-stream-prefix" : "${var.app_name}-${var.app_environment}-mongodb"
        }
      },
      "portMappings" : [
        { "containerPort" : 27017, "hostPort" : 27017, "protocol" : "tcp" }
      ],
      "networkMode" : "awsvpc",
    }
  ])

  tags = {
    Name        = "${var.app_name}-mongodb-td"
    Environment = var.app_environment
  }
}

# Serviço para o contêiner do MongoDB
resource "aws_ecs_service" "mongodb_service" {
  name                 = "${var.app_name}-service2"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.mongodb_task.family
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
    security_groups = [
      aws_security_group.security_group.id,
      # aws_security_group.load_balancer_security_group.id
    ]
  }
}
