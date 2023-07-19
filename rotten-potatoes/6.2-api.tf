# Definição de tarefa para o contêiner do Rotten Potatoes
resource "aws_ecs_task_definition" "rotten_potatoes_task" {
  family                   = "rotten_potatoes_task"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"

  container_definitions = jsonencode([
    {
      "name" : "${var.app_name}-service1",
      "image" : "tscampos/rotten-potatoes:v1",
      "entryPoint" : [],
      "environment" : [
        { "name" : "MONGODB_HOST", "value" : "${var.app_name}-service2" },
        { "name" : "MONGODB_USERNAME", "value" : "mongodbuser" },
        { "name" : "MONGODB_PASSWORD", "value" : "mongodbpwd" },
        { "name" : "MONGODB_PORT", "value" : "27017" },
        { "name" : "MONGODB_DB", "value" : "admin" }
      ],
      "essential" : true,
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.log-group.id,
          "awslogs-region" : var.aws_region,
          "awslogs-stream-prefix" : "${var.app_name}-${var.app_environment}-rotten-potatoes"
        }
      },
      "portMappings" : [
        { "containerPort" : 5000, "protocol" : "tcp" }
      ],
      "networkMode" : "awsvpc"
    }
  ])

  tags = {
    Name        = "${var.app_name}-rotten-potatoes-td"
    Environment = var.app_environment
  }
}


# Serviço para o contêiner do Rotten Potatoes
resource "aws_ecs_service" "rotten_potatoes_service" {
  name                 = "${var.app_name}-service1"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.rotten_potatoes_task.family
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 2
  force_new_deployment = true

  # depends_on = [aws_ecs_service.mongodb_service]

  network_configuration {
    subnets          = aws_subnet.public.*.id
    assign_public_ip = true
    security_groups = [
      aws_security_group.security_group.id,
      # aws_security_group.load_balancer_security_group.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "${var.app_name}-service1"
    container_port   = 5000
  }
}
