resource "aws_cloudwatch_log_group" "fargate" {
  name              = "/ecs/fargate-petclinic"
  retention_in_days = 30

  tags = {
    Name = "ecs-fargate-logs"
  }
}
