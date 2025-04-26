resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/ec2-petclinic"
  retention_in_days = 30

  tags = {
    Name = "ecs-ec2-logs"
  }
}
