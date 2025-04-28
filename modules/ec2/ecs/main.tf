resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_ecs_task_definition" "app" {
  family             = "ecs-ec2-task"
  network_mode       = "awsvpc"
  execution_role_arn = var.lab_role_arn
  task_role_arn      = var.lab_role_arn
  cpu                = 1024
  memory             = 1536

  container_definitions = jsonencode([{
    name  = "petclinic"
    image = "${var.docker_image}"
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
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])

  tags = {
    Name = "ecs-ec2-task"
  }
}

resource "aws_ecs_service" "app" {
  name            = "ecs-ec2-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 3

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  network_configuration {
    security_groups = [var.tasks_security_group_id]
    subnets         = var.subnet_ids
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ec2.name
    weight            = 100
    base              = 1
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "petclinic"
    container_port   = 8080
  }

  depends_on = [var.target_group_arn, aws_ecs_capacity_provider.ec2]

  tags = {
    Name = "ecs-ec2-service"
  }
}

# Capacity Provider Associate with ASG
resource "aws_ecs_capacity_provider" "ec2" {
  name = "ec2-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.asg_arn

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }

  tags = {
    Name = "ecs-ec2-capacity-provider"
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [aws_ecs_capacity_provider.ec2.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ec2.name
  }
}
