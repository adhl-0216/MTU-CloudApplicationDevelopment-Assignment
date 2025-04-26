module "logging" {
  source = "./logging"
}

module "alb" {
  source     = "./alb"
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
}

module "ecs" {
  source = "./ecs"

  cluster_name = var.cluster_name
  lab_role_arn = var.lab_role_arn
  docker_image = var.docker_image
  aws_region   = var.aws_region
  subnet_ids   = var.subnet_ids

  log_group_name   = module.logging.log_group_name
  target_group_arn = module.alb.target_group_arn

  tasks_security_group_id = module.alb.tasks_security_group_id

  depends_on = [module.alb, module.logging]
}
