#Elastic Container Repository

resource "aws_ecr_repository" "aws-ecr" {
  name = "${var.app_name}-${var.app_environment}-ecr"
  
  tags = {
    Name        = "${var.app_name}-ecr"
    Environment = var.app_environment
  }
}

resource "null_resource" "push-nginx-image" {
  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.aws-ecr.repository_url}:v1"
  }

  depends_on = [aws_ecr_repository.aws-ecr]
}