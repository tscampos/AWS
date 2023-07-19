resource "aws_ecs_cluster" "my_cluster_ecs" {
    name = "ecs-cluster"

    tags = {
        Name = "MY_cluster_ecs"
  }
}