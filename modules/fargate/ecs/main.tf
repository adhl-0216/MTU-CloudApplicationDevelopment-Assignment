resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "ecs-fargate-task"
  network_mode             = "awsvpc"
  execution_role_arn       = var.lab_role_arn
  task_role_arn            = var.lab_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 2048

  container_definitions = jsonencode([{
    name  = "petclinic"
    image = "${var.docker_image}"
    # essential = true
    portMappings = [
      {
        containerPort = 8080
        protocol      = "tcp"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "${var.log_group_name}"
        "awslogs-region"        = "${var.aws_region}"
        "awslogs-stream-prefix" = "fargate"
      }
    }
  }])

  tags = {
    Name = "ecs-fargate-task"
  }
}

resource "aws_ecs_service" "app" {
  name            = "ecs-fargate-service"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 7

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  network_configuration {
    security_groups = [var.tasks_security_group_id]
    subnets         = var.subnet_ids
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "petclinic"
    container_port   = 8080
  }

  depends_on = [var.target_group_arn]

  tags = {
    Name = "ecs-fargate-service"
  }
}
