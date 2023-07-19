# IAM Role Policies

                                   # CRIA UMA FUNÇÃO ESPECÍFICA PARA A EXECUÇÃO ADEQUADA DO ECS
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.app_name}-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  
  tags = {
    Name        = "${var.app_name}-iam-role"
    Environment = var.app_environment
  }
}

                                   # CRIA UM SERVIÇO PARA ASSUMIR A FUNÇÃO CRIADA
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

                                   # ANEXA UMA POLÍTICA DA AWS À FUNÇÃO CRIADA PARA GARANTIR INTERAÇÃO ENTRE ECS E EC2 E OUTROS SERVIÇOS DA AWS
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}