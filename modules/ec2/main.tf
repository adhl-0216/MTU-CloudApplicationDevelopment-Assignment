module "logging" {
  source = "./logging"
}

module "alb" {
  source = "./alb"

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

  tasks_security_group_id = module.alb.tasks_security_group_id
  target_group_arn        = module.alb.target_group_arn
  log_group_name          = module.logging.log_group_name
  asg_arn                 = module.compute.asg_arn

  depends_on = [module.alb, module.logging]
}

module "compute" {
  source = "./compute"

  cluster_name = var.cluster_name
  aws_region   = var.aws_region
  vpc_id       = var.vpc_id
  subnet_ids   = var.subnet_ids

  target_group_arn = module.alb.target_group_arn
  log_group_name   = module.logging.log_group_name

  depends_on = [module.alb, module.logging]
}
